#!/usr/bin/env python3
import socket
import time

ServerList = { "drive.google.com":'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0' }
wait = 2
counter=0

while 1==1:
    print('-=== Round #',counter,' ===-')
    for ServerName, ServerOldIp in ServerList.items():
        ServerNewIp = socket.gethostbyname(ServerName)
        if ServerNewIp != ServerOldIp:
            print('[ERROR]', ServerName, 'IP mismatch:',ServerOldIp, ServerNewIp )
            ServerList[ServerName] = ServerNewIp
        else:
            print(ServerName, '-', ServerOldIp)
        time.sleep(wait)
    counter+=1
