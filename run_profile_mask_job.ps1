#================================================================================
# File:         run_profile_mask_job.ps1
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
# 	Script to run profile mask job in Delphix Masking engine
#
# Prerequisites:
#   To have jq installed and configured in server/personal computer
#================================================================================
#
#

#Declare our named parameters here...
param(
   [string] $DXM_ENGINE,
   [string] $JQPATH,
   [string] $CURLPATH,
   [string] $JOBID
)


$USERMSK = Read-Host -Prompt "Enter Masking Admin name from $DX_ENGINE_MASK "
$DXPASSW_TGT = Read-Host -Prompt "Enter Masking Admin password from $DX_ENGINE_MASK " -AsSecureString

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DXPASSW_TGT)
$DXPASSWORD_MASK = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

########################################################
###   Login authetication and autokoen capture
$DMURL = "http://" + $DXM_ENGINE + ":8282/masking/api"
Write-Output "Authenticating on $DMURL ---  Masking engine..."


$json = @"
{
    "username": "$USERMSK",
    "password": "$DXPASSWORD_MASK"
}
"@
write-output $json | Out-File "C:\temp\session.json" -encoding utf8

cd $CURLPATH
$STATUS = $(.\curl.exe -sX POST --header "Content-Type: application/json" --header "Accept: application/json" -d "@C:\temp\session.json" -k "$DMURL/login")
write-output $STATUS | Out-File "C:\temp\authorization.log" -encoding utf8

cd $JQPATH
$myLoginToken =  .\jq.exe --raw-output '.Authorization'  "C:\temp\authorization.login"

If ( $myLoginToken -eq 'null' ) {

    Write-Output "Authentication FAILED : LoginToken $myLoginToken"
    exit 1

  }  Else {

  Write-Output "Authentication SUCCESS : LoginToken $myLoginToken"

} 


#########################################################
##   Firing job

$json_2 = @"
{
    "jobId": "$JOBID"   
}
"@
write-output $json_2 | Out-File "C:\temp\jobid.json" -encoding utf8


Write-Output  "Executing job $JOBID"
cd $CURLPATH
$JOBEXEC=$(.\curl.exe -s -X POST --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: $myLoginToken" -d "@C:\temp\jobid.json" "$DMURL/executions")
Write-output $JOBEXEC | Out-File "C:\temp\jobexec.log" -encoding utf8
cd $JQPATH
$GETJOBID =  .\jq.exe --raw-output '.executionId'  "C:\temp\jobexec.log"
$GETJOBSTATUS =  .\jq.exe --raw-output '.status'  "C:\temp\jobexec.log"
Write-output  "Execution Id: $GETJOBID"
Write-output  "Job Execution status: $GETJOBSTATUS"
exit 0
#########################################################