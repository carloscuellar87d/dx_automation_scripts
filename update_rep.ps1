#================================================================================
# File:         update_rep.ps1
# Type:         power-shell script
# Date:         9-April 2019
# Author:       v1- Carlos Cuellar - Delphix Professional Services
# Ownership:    This script is owned and maintained by the user, not by Delphix
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Copyright (c) 2019 by Delphix. All rights reserved.
#
# Description:
#
# 	Script to be used to update replication profile from  Delphix virtualization engine
#   to add or delete datasets.
#
# Prerequisites:
#   To have putty and plink  installed in server/personal computer
#   To have write access to C:\temp
#   Make sure that replication profile was created selecting the dataset group, that way it will get updated when a new vDB is created.
#
# Usage:
#   update_rep.ps1 <SOURCE_DELPHIX_ENGINE_HOSTNAME> <REPLICATION_PROFILE> <PUTTY_PATH> <REPLICATION_OBJECT>
#
# Example: 
#   update_rep.ps1 delphix5330 ReplicationProfile1 "C:\putty" "Oracle Sources"
#
#================================================================================

#Declare our named parameters here...
param(
   [string] $DX_ENGINE_SRC,
   [string] $REPPROFILE,
   [string] $PUTTY_PATH,
   [string] $DX_OBJ_REP
)

Write-Output "Updating datasets for $REPPROFILE environment in $DX_ENGINE_SRC ..."

$DXNAME_SRC = Read-Host -Prompt "Enter Delphix Admin name from $DX_ENGINE_SRC "
$DXPASSW_SRC = Read-Host -Prompt "Enter Delphix Admin password from $DX_ENGINE_SRC " -AsSecureString

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DXPASSW_SRC)
$DXPASSWORD_SRC = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

New-Item -Path C:\temp\dx_replication_update.txt -ItemType File| Out-Null
$TEMP_SCRIPT="replication spec;select `"$REPPROFILE`"; ls"
Set-Content C:\temp\dx_replication_update.txt  $TEMP_SCRIPT

cd $PUTTY_PATH
.\plink.exe -batch $DXNAME_SRC@$DX_ENGINE_SRC  -pw $DXPASSWORD_SRC $TEMP_SCRIPT >> "C:\temp\dx_replication_update_LOG.txt"
cat "C:\temp\dx_replication_update_LOG.txt"| Select-String -Pattern "objects:" >> "C:\temp\dx_replication_curobj.txt"

$DXREP_OBJ_CURRENT= [IO.File]::ReadAllText("C:\temp\dx_replication_curobj.txt")
$DXREP_OBJ_CURRENT_F= $DXREP_OBJ_CURRENT.split(":")[-1]
$DXREP_OBJ_CURRENT_F=$DXREP_OBJ_CURRENT_F.trim()

$REPQ= Read-Host -Prompt 'Do you want add or delete a dataset in Replication profile?: (A)dd/(D)el '
If ( $REPQ -eq 'A') {
  
    $DX_OBJ_REP_FINAL="$DXREP_OBJ_CURRENT_F,$DX_OBJ_REP"

  }  ElseIf ( $REPQ -eq 'D')  {

    $DX_OBJ_REP_FIN=$DXREP_OBJ_CURRENT_F.replace("$DX_OBJ_REP","")

    if ( $DX_OBJ_REP_FIN.startswith(",") )
    {
        $DX_OBJ_REP_FINAL= $DX_OBJ_REP_FIN.Substring(1)
    }
    if ( $DX_OBJ_REP_FIN.endswith(",") )
    {
        $DX_OBJ_REP_FINAL= $DX_OBJ_REP_FIN.Substring(0,$DX_OBJ_REP_FIN.Length-1)
    }

  }  Else {

  'Please answer A or D.'
  exit 1

} 




New-Item -Path C:\temp\dx_replication_upd.txt -ItemType File| Out-Null
$TEMP_SCRIPT="replication spec;select `"$REPPROFILE`"; update ; set objectSpecification.objects=`"$DX_OBJ_REP_FINAL`"; commit"
Set-Content C:\temp\dx_replication_upd.txt  $TEMP_SCRIPT
.\putty.exe -ssh $DXNAME_SRC@$DX_ENGINE_SRC  -pw $DXPASSWORD_SRC -m C:\temp\dx_replication_upd.txt

Start-Sleep -s 30
Remove-Item -path C:\temp\dx_replication_update_LOG.txt
Remove-Item -path C:\temp\dx_replication_curobj.txt
Remove-Item -path C:\temp\dx_replication_update.txt
Remove-Item -path C:\temp\dx_replication_upd.txt

exit 0
#end of script


