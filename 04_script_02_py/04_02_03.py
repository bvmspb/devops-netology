#!/usr/bin/env python3

import os
import sys

if ( len(sys.argv) == 1 ):
    print("Use full directory path as an argument.\n Example:")
    print(sys.argv[0],"/home/user/git/repository/")
    exit()    

path = sys.argv[1]

#print( 'Number of arguments',len(sys.argv) )
#print( 'Is directory', os.path.isdir(sys.argv[1]) )
if os.path.isdir(sys.argv[1]):
    bash_command = ["cd "+path, "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    #is_change = False
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(path+prepare_result)
    #        break
else:
    print("Use full directory path as an argument.\n Example:")
    print(sys.argv[0],"/home/user/git/repository/")
    exit()

