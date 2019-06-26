#================================================================================
# File:         create_app_env_mask.ps1
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
# 	Script to be used to create Applicatn and  Environment in Delphix Masking engine
#
# Prerequisites:
#   To have dxm-toolkit configured in server/personal computer
#
# Usage:
#   create_app_env_mask.ps1 <DELPHIX_ENGINE_FROM_DXMTOOLKIT> <DXMTOOLKIT_PATH> <APPLICATION_NAME> <ENVIRONMENT_NAME>
#
# Example: 
#   create_app_env_mask.ps1 delphix5330 "C:\Program Files\Delphix\dxmc-0.42-5.3.2" application1  environment1
#
#================================================================================
#


#Declare our named parameters here...
param(
   [string] $DX_ENGINE,
   [string] $DXMTOOLKIT_PATH,
   [string] $APPNAME,
   [string] $ENVNAME
   #[string] $CONNAME,
   #[string] $CONTYPE,
   #[string] $CONSERVER,
   #[string] $CONPORT,
   #[string] $CONSCHEMA
)


Write-Output "Adding $APP_NAME application and $ENVNAME environment to $DX_ENGINE Masking engine..."

cd $DXMTOOLKIT_PATH

.\dxmc.exe application add --appname $APPNAME --engine $DX_ENGINE

.\dxmc.exe environment add --envname $ENVNAME --appname $APPNAME --engine $DX_ENGINE



#If ( $CONNTYPE -eq 'mssql') {
  
#    .\dxmc.exe connector add --connectorname $CONNAME --envname $ENVNAME  --connectortype $CONNTYPE --host $CONSERVER --port $CONPORT --schemaname $CONSCHEMA --username $CONUSER
 
#   }  ElseIf ( $CONNTYPE -eq 'oracle')  {
     
#    $CONSID= Read-Host -Prompt 'Please provide the SID: '
#    .\dxmc.exe connector add --connectorname $CONNAME --envname $ENVNAME  --connectortype $CONNTYPE --host $CONSERVER --port $CONPORT --schemaname $CONSCHEMA --username $CONUSER --sid $CONSID

 
#   }  Else {
 
#    Write-Output "Value not valid! Exiting now..."
#    exit 1
 
# } 
 
 #ADD RULESET BUT DOESNT CHECK THE TABLES, THAT NEEDS TO BE DONE MANUALLY
#.\dxmc.exe ruleset add --rulesetname  $RULESETNAME --connectorname $CONNAME --envname $ENVNAME


exit 0
#end of script