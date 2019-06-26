#================================================================================
# File:         assign_mskjob.ps1
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
# 	Script to be used to assing a masking job to a  dSource/vDB in a Delphix virtualization engine from a Masking engine
#
# Prerequisites:
#   To have dxtoolkit configured in server/personal computer
#
# Usage:
#   assign_mskjob.ps1 <DELPHIX_ENGINE_FROM_DXTOOLKIT> <DB_NAME> <MASKING_JOB_NAME> <ACTION> <DX_OBJ_TYPE> <DXTOOLKIT_PATH>
#
# Example: 
#   assign_maskjob.ps1 delphix5330 dTEST maskingjobauto assign dsource "C:\Program Files\Delphix\DxToolkit2"
#
#================================================================================
#
# Pending to provision a vDB with masking job
#

#Declare our named parameters here...
param(
   [string] $DX_ENGINE,
   [string] $DB_NAME,
   [string] $MSK_JOB_NAME,
   [string] $ACTION,
   [string] $DX_OBJ_TYPE,
   [string] $DXTOOLKIT_PATH
)

cd $DXTOOLKIT_PATH

Write-Output "Assign  $MSK_JOB_NAME to  $DB_NAME in  $DX_ENGINE..."

.\dx_ctl_maskingjob.exe -d $DX_ENGINE -name $MSK_JOB_NAME -action $ACTION -dbname $DB_NAME -type $DX_OBJ_TYPE

.\dx_get_maskingjob.exe -d $DX_ENGINE -name $MSK_JOB_NAME -format csv| Select-String -pattern delphix > C:\temp\maskingjobtemp.txt

$DXMSK_JOB_FILE_TEMP = [IO.File]::ReadAllText("C:\temp\maskingjobtemp.txt")
$DXMSK_JOB_FILE = $DXMSK_JOB_FILE_TEMP.split(",")
$DXMSK_DBNAME=$DXMSK_JOB_FILE[2].trim()


If ( $DXMSK_DBNAME -eq $DB_NAME) {
  
    Write-Output "Masking job $MSK_JOB_NAME was added properly to $DB_NAME"
    exit 0
 
   }  Else {
 
    Write-Output "Masking job $MSK_JOB_NAME was NOT added properly to $DB_NAME... please review ..."
    exit 1
 
 } 

exit 0
#end of script