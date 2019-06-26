#================================================================================
# File:         delete_rep.ps1
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
# 	Script to be used to delete replication profile from  Delphix virtualization engine
#
# Prerequisites:
#   To have putty installed in server/personal computer
#   To have write access to C:\temp
#   Make sure that replication profile was created selecting the dataset group, that way it will get updated when a new vDB is created.
#
# Usage:
#   delete_rep.ps1 <SOURCE_DELPHIX_ENGINE_HOSTNAME> <REPLICATION_PROFILE> <PUTTY_PATH>
#
# Example: 
#   delete_rep.ps1 delphix5330 ReplicationProfile1 "C:\putty"
#
#================================================================================

#Declare our named parameters here...
param(
   [string] $DX_ENGINE_SRC,
   [string] $REPPROFILE,
   [string] $PUTTY_PATH
)

Write-Output "Delete $REPPROFILE  in $DX_ENGINE_SRC ..."

$DXNAME_SRC = Read-Host -Prompt "Enter Delphix Admin name from $DX_ENGINE_SRC "
$DXPASSW_SRC = Read-Host -Prompt "Enter Delphix Admin password from $DX_ENGINE_SRC " -AsSecureString

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DXPASSW_SRC)
$DXPASSWORD_SRC = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)


New-Item -Path C:\temp\dx_replication_delete.txt -ItemType File| Out-Null
$TEMP_SCRIPT="replication spec; select `"$REPPROFILE`";delete; commit"
Set-Content C:\temp\dx_replication_delete.txt  $TEMP_SCRIPT

cd $PUTTY_PATH
.\putty.exe -ssh $DXNAME_SRC@$DX_ENGINE_SRC  -pw $DXPASSWORD_SRC -m C:\temp\dx_replication_delete.txt
Start-Sleep -s 10
Remove-Item -path C:\temp\dx_replication_delete.txt

exit 0
#end of script
