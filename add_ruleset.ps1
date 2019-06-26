#================================================================================
# File:         add_ruleset.ps1
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
# 	Script to be used to Add ruleset in Delphix Masking engine
#
# Prerequisites:
#   To have dxtoolkit configured in server/personal computer
#
# Usage:
#   add_ruleset.ps1 <DELPHIX_ENGINE_FROM_DXMTOOLKIT> <DXMTOOLKIT_PATH> <RULESET_NAME> <ENVIRONMENT_NAME> <CONNECTOR_NAME> 
#
# Example: 
#   add_ruleset.ps1 delphix5330 "C:\Program Files\Delphix\dxmc-0.42-5.3.2" ruleset1  environment1 sqlserverconnector
#
#================================================================================
#


#Declare our named parameters here...
param(
   [string] $DX_ENGINE,
   [string] $DXMTOOLKIT_PATH,
   [string] $RULESETNAME,
   [string] $ENVNAME,
   [string] $CONNAME
)


Write-Output "Adding $APP_NAME application and $ENVNAME environment to $DX_ENGINE Masking engine..."

cd $DXMTOOLKIT_PATH

# } 
 
 #ADD RULESET BUT DOESNT CHECK THE TABLES, THAT NEEDS TO BE DONE MANUALLY
.\dxmc.exe ruleset add --rulesetname  $RULESETNAME --connectorname $CONNAME --envname $ENVNAME --engine $DX_ENGINE

#This doesnt set the tables to be added to the inventory

exit 0
#end of script