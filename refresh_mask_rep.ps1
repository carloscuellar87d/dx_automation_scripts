#================================================================================
# File:         refresh_mask_rep.ps1
# Type:         power-shell script
# Date:         3-May 2019
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
#   To have dxtoolkit configured in server/personal computer and both Source Engine and Target Engine are configured in dxtools.conf
#   Make sure that replication profile was created selecting the dataset group, that way it will get updated when a new vDB is created.
#
# Usage:
#   refresh_mask_rep.ps1 <DELPHIX_ENGINE_SOURCE> <DELPHIX_ENGINE_TARGET> <vDB SOURCE> <vDB PARENT TARGET> <Child vDB Self Service container> <REPLICATION_PROFILE>  <DXTOOLKIT_PATH>
#
# Example: 
#   refresh_mask_rep.ps1 delphix5330 delphix5330dev maskingvdb2 vdb_dev container ReplicationProfile1 "C:\Program Files\Delphix\DxToolkit2"
#
#================================================================================
#
#Declare our named parameters here...
param(
   [string] $DX_ENGINE_SRC,
   [string] $DX_ENGINE_TGT,
   [string] $VDB_SRC,
   [string] $VDB_TGT,
   [string] $CONTAINER,
   [string] $REPPROFILE,
   [string] $DXTOOLKIT_PATH
)

cd $DXTOOLKIT_PATH

Write-Output "Refresh $VDB_SRC to latest snapshot in $DX_ENGINE_SRC. If this vdb $VDB_SRC has already a masking job configured, it  will kick it off..."

.\dx_refresh_db.exe -d $DX_ENGINE_SRC -name $VDB_SRC -type vdb

Write-Output "Start replication for profile $REPPROFILE from $DX_ENGINE_SRC..."

.\dx_ctl_replication.exe -d $DX_ENGINE_SRC -profilename $REPPROFILE -safe

Write-Output "After replication is completed, refresh  $VDB_TGT to latest snapshot in $DX_ENGINE_TGT..."

.\dx_refresh_db.exe -d $DX_ENGINE_TGT -name $VDB_TGT -type vdb

Write-Output "Now refresh  $CONTAINER to latest snapshot in $DX_ENGINE_TGT..."

.\dx_ctl_js_container.exe -d $DX_ENGINE_TGT -container_name $CONTAINER -action refresh

exit 0
#end of script