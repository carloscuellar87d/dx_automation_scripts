#================================================================================
# File:         dx_stop_all_vdbs.py
# Type:         python script
# Date:         07-June 2019
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
#       Script to stop all Oracle and MS SQL Server vDBs from a Delphix Engine
#
#Prerequisites:
#
#       Need to have python installed
#
#Usage:
#
#       python dx_stop_all_vdbs.py
#
#================================================================================
#
#Please update the following variables with your Delphix Admin credentials and Delphix Engine URL
DMUSER='admin'
DMPASS='delphix'
BASEURL='http://172.16.126.156/resources/json/delphix'


import requests
import json
import time


print ('Starting script to shut down all vDBs in engine ...')

#
# Request Headers ...
#
req_headers = {
   'Content-Type': 'application/json'
}

#
# Python session, also handles the cookies ...
#
session = requests.session()

#
# Create session ...
#
formdata = '{ "type": "APISession", "version": { "type": "APIVersion", "major": 1, "minor": 10, "micro": 0 } }'
r = session.post(BASEURL+'/session', data=formdata, headers=req_headers, allow_redirects=False)

#
# Login ...
#
formdata = '{ "type": "LoginRequest", "username": "' + DMUSER + '", "password": "' + DMPASS + '" }'
r = session.post(BASEURL+'/login', data=formdata, headers=req_headers, allow_redirects=False)

#
# Get source details
#
r = session.get(BASEURL+'/source', data=formdata, headers=req_headers, allow_redirects=False)
j = json.loads(r.text)

#
# Get Database results
#
s = session.get(BASEURL+'/database', data=formdata, headers=req_headers, allow_redirects=False)
k = json.loads(s.text)

#
# Look for all vDBs and stop them
#

for dbobj in j['result']:
	if dbobj['virtual'] == True:
		DBNAME = dbobj['name']
		VDBREF = dbobj['reference']
		for dbobj2 in k['result']:
			if DBNAME == dbobj2['name']:
				VDBSTATUS = dbobj['runtime']['status']
				if VDBSTATUS == 'RUNNING':
					if dbobj2['runtime']['type'] == 'MSSqlDBContainerRuntime':
						if dbobj2['provisionContainer'] != 'null':
							formdata = '{ "type": "SourceStopParameters" }'
							print ('Stopping vDB ' + DBNAME)
							rexec = session.post(BASEURL+'/source/'+VDBREF+'/stop', data=formdata, headers=req_headers, allow_redirects=False)
							time.sleep(1)
							print ('Stopped vDB ' + DBNAME + ' successfully')
					elif dbobj2['contentType'] != 'ROOT_CDB':
						formdata = '{ "type": "OracleStopParameters" }'
						print ('Stopping vDB ' + DBNAME)
						rexec = session.post(BASEURL+'/source/'+VDBREF+'/stop', data=formdata, headers=req_headers, allow_redirects=False)
						time.sleep(1)
						print ('Stopped vDB ' + DBNAME + ' successfully')
				else:
					print ('vDB ' + DBNAME + ' is already down.')

#
# Give 60 seconds for all vDBs to go down
#
time.sleep(60)


#
# Check if all vDBs are indeed down
#
r = session.get(BASEURL+'/source', data=formdata, headers=req_headers, allow_redirects=False)
j = json.loads(r.text)


for dbobj in j['result']:
        if dbobj['virtual'] == True:
                DBNAME = dbobj['name']
                VDBREF = dbobj['reference']
                for dbobj2 in k['result']:
                        if DBNAME == dbobj2['name']:
                                VDBSTATUS = dbobj['runtime']['status']
                                if VDBSTATUS == 'RUNNING':
                                        if dbobj2['runtime']['type'] == 'MSSqlDBContainerRuntime':
                                                if dbobj2['provisionContainer'] != 'null':
                                                        print ('Could not stop vDB ' + DBNAME + '. Please review the logs.')
                                        elif dbobj2['contentType'] != 'ROOT_CDB':
                                                print ('Could not stop vDB ' + DBNAME + '. Please review the logs.')
