#================================================================================
# File:         add_dsource.ps1
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
# 	Script to be used to Add dSource in Delphix virtualization engine.
#   This version only works to add MS SQL Server dSources.
#
# Prerequisites:
#   To have dxtoolkit configured in server/personal computer
#   Dataset Group in Delphix should be created in advance
#
# Usage:
#   add_dsource.ps1 <DELPHIX_ENGINE_FROM_DXTOOLKIT> <SOURCE_NAME> <DSOURCE_NAME> <DXTOOLKIT_PATH> <ENVIRONMENT_NAME> <DSOURCE_TYPE> <DATASET_GROUP> <STAGING_NAME>
#
# Example: 
#   add_dsource.ps1 delphix5330 TEST dTEST "C:\Program Files\Delphix\DxToolkit2" windowstarget mssql "SQL Server" windowstarget
#
#================================================================================
# Pending to add masking job to dsource
#
#Declare our named parameters here...
param(
   [string] $DX_ENGINE,
   [string] $SOURCE_NAME,
   [string] $DSOURCE_NAME,
   [string] $DXTOOLKIT_PATH,
   [string] $ENVNAME,
   [string] $DSRCTYPE,
   [string] $DSGROUP,
   [string] $STG_NAME
)


Write-Output "Adding $DSOURCE_NAME dSource to $DX_ENGINE ..."

If ( $DSRCTYPE -eq 'mssql') {
  
   Write-Output "This script works only for MS SQL Server dSources, continuing now..."

  }  Else {

   Write-Output "This script works only for MS SQL Server dSources, exiting now."
   exit 1

} 

$OSNAME = Read-Host -Prompt 'Enter Source OS User name: '
$STGOSNAME = Read-Host -Prompt 'Enter Staging OS User name: '
$DBNAME = Read-Host -Prompt 'Enter Source DB User name: '
$DBPASSW = Read-Host -Prompt 'Enter Source DB User Password: ' -AsSecureString

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPASSW)
$DBPASSWORD = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Output "Refreshing $ENVNAME environment ..."
cd $DXTOOLKIT_PATH
.\dx_ctl_env.exe -d $DX_ENGINE -name $ENVNAME -action refresh

$DMBKPS= Read-Host -Prompt 'Do you want to use Delphix Managed Backups?: Y/N '


If ( $DMBKPS -eq 'Y') {
  
   Write-Output "Adding dSource $DSOURCE_NAME in $DX_ENGINE ..."
   .\dx_ctl_dsource.exe -d $DX_ENGINE -type $DSRCTYPE -sourcename $SOURCE_NAME  -sourceinst MSSQLSERVER -sourceenv $ENVNAME -source_os_user $OSNAME -dbuser $DBNAME -password $DBPASSWORD -group $DSGROUP -dsourcename $DSOURCE_NAME -stage_os_user $STGOSNAME -stageinst MSSQLSERVER -stageenv $STG_NAME -delphixmanaged yes -action create
   exit 0

  }  ElseIf ( $DMBKPS -eq 'N')  {
	
   'No Delphix Managed Backups'

  }  Else {

  'Please answer Y or N.'

} 

$BKP_PATH = Read-Host -Prompt 'Do you want to provide MS SQL Backup location?: Y/N '

  If ( $BKP_PATH -eq 'Y')  {

  $BKP_LOC = Read-Host -Prompt 'Enter Backup location: '
  Write-Output "Adding dSource $DSOURCE_NAME in $DX_ENGINE ..."
  .\dx_ctl_dsource.exe -d $DX_ENGINE -type $DSRCTYPE -sourcename $SOURCE_NAME  -sourceinst MSSQLSERVER -sourceenv $ENVNAME -source_os_user $OSNAME -dbuser $DBNAME -password $DBPASSWORD -group $DSGROUP -dsourcename $DSOURCE_NAME -stage_os_user $STGOSNAME -stageinst MSSQLSERVER -stageenv $STG_NAME -backup_dir $BKP_LOC -action create
  exit 0

  }  ElseIf ( $BKP_PATH -eq 'N')  {

  Write-Output "Adding dSource $DSOURCE_NAME in $DX_ENGINE ..."
  .\dx_ctl_dsource.exe -d $DX_ENGINE -type $DSRCTYPE -sourcename $SOURCE_NAME  -sourceinst MSSQLSERVER -sourceenv $ENVNAME -source_os_user $OSNAME -dbuser $DBNAME -password $DBPASSWORD -group $DSGROUP -dsourcename $DSOURCE_NAME -stage_os_user $STGOSNAME -stageinst MSSQLSERVER -stageenv $STG_NAME -action create
  exit 0

  }  Else {

  'Please answer Y or N.'

} 

exit 0
#end of script
