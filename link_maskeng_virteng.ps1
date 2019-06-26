#================================================================================
# File:         link_maskeng_virteng.ps1
# Type:         power-shell script
# Date:         16-April 2019
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
# 	Script to be used to link a Delphix Virtualization engine with Delphix Masking engine 
#
# Prerequisites:
#   To have putty installed in server/personal computer
#   To have write access to C:\temp
#   Make sure that replication profile was created selecting the dataset group, that way it will get updated when a new vDB is created.
#
# Usage:
#   link_maskeng_virteng.ps1 <DELPHIX_VIRTUALIZATION_ENGINE> <PUTTY_PATH> <DELPHIX_MASKING_ENGINE>
#
# Example: 
#   link_maskeng_virteng.ps1 delphix5330 "C:\putty" delphix5330_replica
#
#================================================================================
#
#Declare our named parameters here...
param(
   [string] $DX_ENGINE_VIRT,
   [string] $PUTTY_PATH,
   [string] $DX_ENGINE_MASK
)

Write-Output "Link  $DX_ENGINE_VIRT with $DX_ENGINE_MASK ..."

$DXNAME_SRC = Read-Host -Prompt "Enter Delphix Admin name from $DX_ENGINE_SRC "
$DXPASSW_SRC = Read-Host -Prompt "Enter Delphix Admin password from $DX_ENGINE_SRC " -AsSecureString

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DXPASSW_SRC)
$DXPASSWORD_SRC = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$USERMSK = Read-Host -Prompt "Enter Masking Admin name from $DX_ENGINE_MASK "
$DXPASSW_TGT = Read-Host -Prompt "Enter Masking Admin password from $DX_ENGINE_MASK " -AsSecureString

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DXPASSW_TGT)
$DXPASSWORD_MASK = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

New-Item -Path C:\temp\dx_link_virt_mask.txt -ItemType File| Out-Null
$TEMP_SCRIPT="maskingjob serviceconfig;select `MASKING_SERVICE_CONFIG-1; update; set username=`"$USERMSK`"; set server=$DX_ENGINE_MASK; edit credentials; set password=`"$DXPASSWORD_MASK`"; commit; cd ; maskingjob; fetch; commit;"
Set-Content C:\temp\dx_link_virt_mask.txt  $TEMP_SCRIPT

cd $PUTTY_PATH
.\putty.exe -ssh $DXNAME_SRC@$DX_ENGINE_VIRT  -pw $DXPASSWORD_SRC -m C:\temp\dx_link_virt_mask.txt
Start-Sleep -s 10
Remove-Item -path C:\temp\dx_link_virt_mask.txt

exit 0
#end of script
