#!/usr/bin/python3
# goal: output a list of recommended commands based on parameter 1

import argparse

commandDict = {         # this dictionary will map command categories to lists of commands
"--pass-the-hash" : [""],
"--brute-force" : [""],
"--port-scan" : [""],
"--web-app-discovery" : [""],
"--reverse-shells" : [""],
"--remote-access" : [""],
"--cracking" : [""],
"--file-transfers" : [""],
"--tunnel-pivot" : [""]
}

def parseArguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('--pass-the-hash', action='store_true')
    parser.add_argument('--brute-force', action='store_true')
    parser.add_argument('--port-scan', action='store_true')
    parser.add_argument('--web-app-discovery', action='store_true')
    parser.add_argument('--reverse-shells', action='store_true')
    parser.add_argument('--remote-access', action='store_true')
    parser.add_argument('--cracking', action='store_true')
    parser.add_argument('--file-transfers', action='store_true')
    parser.add_argument('--tunnel-pivot', action='store_true')
    args = parser.parse_args()
    # print(type(args))
    return args

def process(arguments):


if __name__ == "__main__":
    process(parseArguments())
