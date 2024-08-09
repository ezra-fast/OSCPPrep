#!/usr/bin/python3
# goal: output a list of recommended commands based on parameter 1

# access the arguments as a dictionary via: vars(args)

import argparse
import sys

def argCheck():
    if len(sys.argv) != 2:
        print(f"[+] Requires 1 positional argument.\n[+] choose one of the following:\n")
        for command in commandDict:
            this = command.replace('_', '-')
            print(this)
        print("\n[!] Exiting...")

commandDict = {         # this dictionary will map command categories to lists of commands
"pass_the_hash" : [""],
"brute_force" : [""],
"port_scan" : [""],
"web_app_discovery" : [""],
"reverse_shells" : [""],
"remote_access" : [""],
"cracking" : [""],
"file_transfers" : [""],
"tunnel_pivot" : [""]
}

def parseArguments():                                                   # this dictionary takes in and parses the command line arguments
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
    return args

def process(arguments):
     adHocDict = vars(arguments)
     for key in adHocDict.keys():
         if adHocDict[key]:
             for command in commandDict[key]:
                 print(command)                     # this is the line that prints out the commands in a given commandDict category
         else:
             pass

if __name__ == "__main__":
    argCheck()
    process(parseArguments())
