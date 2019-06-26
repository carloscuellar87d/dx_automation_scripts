#================================================================================
# File:         create_connector_mask.ps1
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
# 	Script to be used to create DB connector in Masking engine
#
# Prerequisites:
#   To have dxtoolkit configured in server/personal computer
#
# Usage:
#   create_connector_mask.ps1 <DELPHIX_ENGINE_FROM_DXMTOOLKIT> <JQ_PATH> <CURL_PATH> <ENVIRONMENT_ID> <DB_CONNECTOR_ID> <CONNECTOR_NAME> <DB_TYPE> <DB_NAME> <HOST> <PORT> <SCHEMA_NAME>
#
# Example: 
#   create_connector_mask.ps1 172.16.126.160 "C:\temp" "C:\temp\curl-7.64.1-win64-mingw\curl-7.64.1-win64-mingw\bin" 1 3 CHARLYAUTO MSSQL TEST 172.16.126.135 1433 dbo
#
#================================================================================
#
#

#Declare our named parameters here...
param(
   [string] $DXM_ENGINE,
   [string] $JQPATH,
   [string] $CURLPATH,
   [string] $ENVID,
   [string] $DBCONNID,
   [string] $CONNAME,
   [string] $DBTYPE,
   [string] $DBNAME,
   [string] $SQLTGT,
   [string] $PORT,
   [string] $SCHEMANAME
)


If ( $DBTYPE -eq 'MSSQL') {
  
    Write-Output "This script works only for MS SQL Server DBs, continuing now..."
 
   }  Else {
 
    Write-Output "This script works only for MS SQL Server DBs, exiting now."
    exit 1
 
 } 

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
write-output $STATUS | Out-File "C:\temp\authorization.login" -encoding utf8

cd $JQPATH
$myLoginToken =  .\jq.exe --raw-output '.Authorization'  "C:\temp\authorization.login"

If ( $myLoginToken -eq 'null' ) {

    Write-Output "Authentication FAILED : LoginToken $myLoginToken"
    exit 1

  }  Else {

  Write-Output "Authentication SUCCESS : LoginToken $myLoginToken"

} 

$DBUSER = Read-Host -Prompt "Enter DB User name for new connector: "
$DBPASSWD = Read-Host -Prompt "Enter DB User password for new connector " -AsSecureString

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPASSWD)
$DBPASSWD_MSK = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)


$json_2 = @"
{
    "databaseConnectorId": "$DBCONNID",
    "connectorName": "$CONNAME",
    "databaseType": "$DBTYPE",  
    "environmentId": "$ENVID",
    "databaseName": "$DBNAME",
    "host": "$SQLTGT",
    "port": $PORT,
    "schemaName": "$SCHEMANAME",
    "username": "$DBUSER",
    "password": "$DBPASSWD_MSK"
}
"@
write-output $json_2 | Out-File "C:\temp\create_conn_msk.json" -encoding utf8



cd $CURLPATH
$CREATE_CONNECTOR = $(.\curl.exe -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header "Authorization: $myLoginToken" -d "@C:\temp\create_conn_msk.json" "$DMURL/database-connectors")
write-output $CREATE_CONNECTOR | Out-File "C:\temp\CREATE_CONNECTOR.log" -encoding utf8 

exit 0