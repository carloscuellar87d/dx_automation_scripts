#================================================================================
# File:         create_job_mask.ps1
# Type:         power-shell script
# Date:         8-April 2019
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
# 	Script to be used to create a masking job in Delphix Masking engine
#
# Prerequisites:
#   To have dxm-toolkit configured in server/personal computer
#
# Usage:
#   create_job_mask.ps1 <DELPHIX_ENGINE_FROM_DXMTOOLKIT> <DXMTOOLKIT_PATH> <MASKING_JOB> <ENVIRONMENT_NAME> <RULESET_NAME> <TGT_CONNECTOR>
#
# Example: 
#   create_job_mask.ps1 delphix5330 "C:\Program Files\Delphix\dxmc-0.42-5.3.2" maskingjob1  environment1 ruleset1 sqlconnector
#
#================================================================================
#


#Declare our named parameters here...
param(
   [string] $DX_ENGINE,
   [string] $DXMTOOLKIT_PATH,
   [string] $MASKINGJOBNAME,
   [string] $ENVNAME,
   [string] $RULESETNAME,
   [string] $TGTCONN
)


Write-Output "Creating $MASKINGJOBNAME masking job to $DX_ENGINE Masking engine..."
cd $DXMTOOLKIT_PATH

$TYPEMSKJOB= Read-Host -Prompt 'Do you want to create masking job  $MASKINGJOBNAME In Place or On The Fly: I/O '

If ( $TYPEMSKJOB -eq 'I') {
  
    .\dxmc.exe job add --jobname $MASKINGJOBNAME --envname $ENVNAME --rulesetname $RULESETNAME --multi_tenant Y --engine $DX_ENGINE

   }  ElseIf ( $TYPEMSKJOB -eq 'O')  {

    Write-Output "Feature not added yet..."
    #$RUNMSKJOB_OTF= Read-Host -Prompt 'Provide the On The Fly source connector:  '
    #.\dxmc.exe job add --jobname $MASKINGJOBNAME --envname $ENVNAME --rulesetname $RULESETNAME --multi_tenant Y --engine $DX_ENGINE --on_the_fly_source $ONTHEFLYSRC --on_the_fly Y
    exit 0

   }  Else {
 
    Write-Output "Value not valid! Exiting now..."
    exit 1
 
 } 

$RUNMSKJOB= Read-Host -Prompt 'Do you want to run masking job  $MASKINGJOBNAME: Y/N '

If ( $RUNMSKJOB -eq 'Y') {
  
    Write-Output "Running $MASKINGJOBNAME masking job to $DX_ENGINE Masking engine..."
    .\dxmc.exe job start --jobname $MASKINGJOBNAME --envname $ENVNAME --tgt_connector $TGTCONN
    exit 0

  }  ElseIf ( $RUNMSKJOB -eq 'N')  {

      Write-Output "Script completed."
      exit 0

  }  Else {

  'Please answer Y or N.'
  exit 1

} 

exit 0
#end of script