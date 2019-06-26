#================================================================================
# File:         start_rep.ps1
# Type:         power-shell script
# Date:         9-April 2019
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
# 	Script to be used to start replication from  Delphix virtualization engine
#
# Prerequisites:
#   To have dxtoolkit configured in server/personal computer
#   Make sure that replication profile was created selecting the dataset group, that way it will get updated when a new vDB is created.
#
# Usage:
#   start_rep.ps1 <DELPHIX_ENGINE_FROM_DXTOOLKIT> <DXTOOLKIT_PATH> <REPLICATION_PROFILE>
#
# Example: 
#   start_rep.ps1 delphix5330 "C:\Program Files\Delphix\DxToolkit2" ReplicationProfile1
#
#================================================================================
#
#Declare our named parameters here...
param(
   [string] $DX_ENGINE,
   [string] $DXTOOLKIT_PATH,
   [string] $REPPROFILE
)

cd $DXTOOLKIT_PATH

Write-Output "Get target replication details from $DX_ENGINE..."

.\dx_get_replication.exe -d $DX_ENGINE -format csv| Select-String -Pattern $REPPROFILE > 'C:\temp\dx_rep_log.log'

Get-Content $filename | ForEach-Object {
    $_.split(":")[1]
}

Write-Output "Start replication for profile $REPPROFILE from $DX_ENGINE..."

.\dx_ctl_replication.exe -d $DX_ENGINE -profilename $REPPROFILE -safe -nowait

exit 0
#end of script