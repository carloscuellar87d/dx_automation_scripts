#================================================================================
# File:         prov_vdb.ps1
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
# 	Script to be used to provision vDBs from  Delphix virtualization engine
#
# Prerequisites:
#   To have dxtoolkit configured in server/personal computer
#
# Usage:
#   prov_vdb.ps1 <DELPHIX_ENGINE_FROM_DXTOOLKIT> <DSOURCE_NAME> <ENVIRONMENT_NAME> <VDB_TYPE> <DATASET_GROUP> <VDB_NAME> <DXTOOLKIT_PATH>
#
# Example: 
#   prov_vdb.ps1 delphix5330 dTEST windowstarget mssql "SQL Server" vdbTEST "C:\Program Files\Delphix\DxToolkit2"
#
#================================================================================
#

#Declare our named parameters here...
param(
   [string] $DX_ENGINE,
   [string] $DSOURCE_NAME,
   [string] $ENVNAME,
   [string] $VDBTYPE,
   [string] $DSGROUP,
   [string] $VDBNAME,
   [string] $DXTOOLKIT_PATH
)

cd $DXTOOLKIT_PATH
If ( $VDBTYPE -eq 'mssql') {
  
   Write-Output "This script works only for MS SQL Server dSources, continuing now..."

  }  Else {

   Write-Output "This script works only for MS SQL Server dSources, exiting now."
   exit 1

} 

Write-Output "Provisioning $VDBNAME from $DX_ENGINE to $ENVNAME from latest snapshot..."


$VDBMSK= Read-Host -Prompt 'Do you want to assign a masking job to this vDB?: Y/N '


If ( $VDBMSK -eq 'Y') {

   Write-Output "Here you have the list of masking jobs available to $DX_ENGINE..."
   .\dx_get_maskingjob.exe -d $DX_ENGINE
   $VDBMSKJOB= Read-Host -Prompt 'Please provide the masking job name: '
   .\dx_provision_vdb.exe -d $DX_ENGINE -group $DSGROUP -sourcename $DSOURCE_NAME -targetname $VDBNAME -dbname $VDBNAME -environment $ENVNAME -type $VDBTYPE -envinst MSSQLSERVER -maskingjob $VDBMSKJOB
   exit 0

  }  ElseIf ( $VDBMSK -eq 'N')  {
	
   .\dx_provision_vdb.exe -d $DX_ENGINE -group $DSGROUP -sourcename $DSOURCE_NAME -targetname $VDBNAME -dbname $VDBNAME -environment $ENVNAME -type $VDBTYPE -envinst MSSQLSERVER

  }  Else {

  'Please answer Y or N.'

} 

.\dx_provision_vdb.exe -d $DX_ENGINE -group $DSGROUP -sourcename $DSOURCE_NAME -targetname $VDBNAME -dbname $VDBNAME -environment $ENVNAME -type $VDBTYPE -envinst MSSQLSERVER

exit 0
#end of script