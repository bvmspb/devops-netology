#!/usr/bin/env python3
import json
import yaml
import socket
import time

jsonFile = '04_03_02.json'
yamlFile = '04_03_02.yaml'
serverList = {"drive.google.com": '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
# with open(jsonFile, 'r') as jsonFD:
#     serverList = json.load(jsonFD)
wait = 2
counter = 0

while True:
    print('-=== Round #', counter, ' ===-')
    for ServerName, ServerOldIp in serverList.items():
        ServerNewIp = socket.gethostbyname(ServerName)
        if ServerNewIp != ServerOldIp:  # ip has changed
            print('[ERROR]', ServerName, 'IP mismatch:', ServerOldIp, ServerNewIp)
            serverList[ServerName] = ServerNewIp
            try:
                with open(jsonFile, 'w') as jsonFD, open(yamlFile, 'w') as yamlFD:
                    json.dump(serverList, jsonFD)
                    yaml.dump(serverList, yamlFD)
            except IOError:
                print("File not found or path is incorrect")
            finally:
                yamlFD.close()
                jsonFD.close()
                print('Updated server list with ip-addresses info is stored in', jsonFile, 'and in', yamlFile)

        else:  # ip address is the same as it was before
            print(ServerName, '-', ServerOldIp)
        time.sleep(wait)
    counter += 1
