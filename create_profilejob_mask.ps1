#================================================================================
# File:         create_profilejob_mask.ps1
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
# 	Script to be used to create profile job and run it  from  Delphix Masking engine
#
# Prerequisites:
#   To have dxm-toolkit configured in server/personal computer
#
# Usage:
#   create_profilejob_mask.ps1 <DELPHIX_ENGINE_FROM_DXMTOOLKIT> <DXMTOOLKIT_PATH> <PROFILE_JOB> <ENVIRONMENT_NAME> <RULESET_NAME> <PROFILE_NAME>
# Where PROFILE_NAME could be "Financial" or "HIPAA"
#
# Example: 
#   create_profilejob_mask.ps1 delphix5330 "C:\Program Files\Delphix\dxmc-0.42-5.3.2" profilejob1  environment1 ruleset1 HIPAA
#
#================================================================================
#


#Declare our named parameters here...
param(
   [string] $DX_ENGINE,
   [string] $DXMTOOLKIT_PATH,
   [string] $PROFILEJOBNAME,
   [string] $ENVNAME,
   [string] $RULESETNAME,
   [string] $PROFSET
)


Write-Output "Adding $PROFILEJOBNAME profile job to $DX_ENGINE Masking engine..."

cd $DXMTOOLKIT_PATH

#$PROFSET= Read-Host -Prompt 'Enter Profileset value: Financial/HIPAA'

If ( $PROFSET -eq 'Financial') {
  
    Write-Output "Profile set value is  valid!..."

   }  ElseIf ( $PROFSET -eq 'HIPAA')  {
     
    Write-Output "Profile set value is  valid!..."
 
   }  Else {
 
    Write-Output "Value not valid! Exiting now..."
    exit 1
 
 } 
 
 #ADD RULESET BUT DOESNT CHECK THE TABLES, THAT NEEDS TO BE DONE MANUALLY
.\dxmc.exe profilejob add --jobname $PROFILEJOBNAME --envname $ENVNAME --rulesetname $RULESETNAME --profilename $PROFSET --multi_tenant N --engine $DX_ENGINE


$RUNPROJOB= Read-Host -Prompt 'Do you want to run profile job  $PROFILEJOBNAME: Y/N '
#Multitenant jobs can not be run.

If ( $RUNPROJOB -eq 'Y') {

    Write-Output "Running $PROFILEJOBNAME masking job to $DX_ENGINE Masking engine..."
    .\dxmc.exe profilejob start --jobname $PROFILEJOBNAME --envname $ENVNAME --monitor --engine $DX_ENGINE 
    echo "Run"
    
    exit 0

  }  ElseIf ( $RUNPROJOB -eq 'N')  {

      Write-Output "Script completed."
      exit 0

  }  Else {

  'Please answer Y or N.'
  exit 1
  
} 

exit 0
#end of script