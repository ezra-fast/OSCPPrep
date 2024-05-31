#!/usr/bin/python3
# this script can quickly extract port numbers from the output of masscan and prepare them for nmap

import sys

def parse(file):
    ports = []
    with open(file, 'r') as f:
        data = f.read()
        new  = data.split('\n')
        for line in new:
            if "open port" in line:
                another = line.split(' ')[3].split('/')[0]
                ports.append(int(another))
    ports.sort()
    counter = 0
    for item in ports:
        ports[counter] = str(item)
        counter += 1
    last = ','.join(ports)
    return last

if __name__ == "__main__":
    print(parse(f"{sys.argv[1]}"))

