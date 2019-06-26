#================================================================================
# File:         add_environment.ps1
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
# 	Script to be used to Add Environment in Delphix virtualization engine
#
# Prerequisites:
#   To have dxtoolkit configured in server/personal computer
#
# Usage:
#   add_env.ps1 <DELPHIX_ENGINE_FROM_DXTOOLKIT> <HOST_TO_ADD_AS_ENV> <DXTOOLKIT_PATH> <ENVIRONMENT_NAME> <ENVIRONMENT_TYPE> <TOOLKIT_HOME>
#
# Example: 
#   add_env.ps1 delphix5330 172.16.126.135 "C:\Program Files\Delphix\DxToolkit2" windowstarget windows  "C:\Program Files\Delphix\DelphixConnector"
#
#================================================================================
#


#Declare our named parameters here...
param(
   [string] $DX_ENGINE,
   [string] $HOSTNAME,
   [string] $DXTOOLKIT_PATH,
   [string] $ENVNAME,
   [string] $ENVTYPE,
   [string] $TOOLKITHOME
)


Write-Output "Adding $ENVNAME environment to $DX_ENGINE ..."

$OSNAME = Read-Host -Prompt 'Enter OS User name: '
$OSPASSW = Read-Host -Prompt 'Enter OS User Password: ' -AsSecureString

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($OSPASSW)
$OSPASSWORD = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

cd $DXTOOLKIT_PATH

If ( $ENVTYPE -eq 'windows') {
  
   Write-Output "Accepted value for environment type : $ENVTYPE"

  }  ElseIf ( $ENVTYPE -eq 'unix')  {
	
   Write-Output "Accepted value for environment type : $ENVTYPE"
   .\dx_create_env.exe -d $DX_ENGINE -envname $ENVNAME -envtype $ENVTYPE -host $HOSTNAME -username $OSNAME -authtype password -password $OSPASSWORD -toolkitdir "$TOOLKITHOME"
   exit 0

  }  Else {

   Write-Output "Value not valid! Exiting now..."
   exit 1

} 


$ENVTYPEWS= Read-Host -Prompt 'Do you want to add a Source or Target?: S/T '

If ( $ENVTYPEWS -eq 'S') {
  
   Write-Output "Adding $ENVNAME source in $DX_ENGINE ..."
   $PROXYSERVER= Read-Host -Prompt 'Enter Proxy Server:  '
   .\dx_create_env.exe -d $DX_ENGINE -envname $ENVNAME -envtype $ENVTYPE -host $HOSTNAME -username $OSNAME -authtype password -password $OSPASSWORD -proxy $PROXYSERVER 
   exit 0

  }  ElseIf ( $ENVTYPEWS -eq 'T')  {

      Write-Output "Adding $ENVNAME target in $DX_ENGINE ..."
      .\dx_create_env.exe -d $DX_ENGINE -envname $ENVNAME -envtype $ENVTYPE -host $HOSTNAME -username $OSNAME -authtype password -password $OSPASSWORD -toolkitdir "$TOOLKITHOME"
      exit 0

  }  Else {

  'Please answer S or T.'

} 




exit 0
#end of script
