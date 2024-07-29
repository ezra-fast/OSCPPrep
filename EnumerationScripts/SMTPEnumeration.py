#!/usr/bin/python3

# this simple script uses an open SMTP port to enumerate SMTP users based on a users.txt file in the working directory

import socket
import sys

ip = sys.argv[1]

def enumerate():
    try:
        with open('users.txt') as f:
            users = f.read().split('\n')
            for user in users:
                user = user.encode()
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                connect = s.connect((ip, 25))
                banner = s.recv(1024)
                print(banner)
                br = b'VRFY '                   # this is a tad voodoo
                uh = b'\r\n'
                s.send(br + user + uh)
                result = s.recv(1024)
                print(result)
            s.close()
    except Exception as e:
        print(f'[!] No users.txt file in the working directory! Exiting...')
        

if __name__ == "__main__":
    enumerate()

