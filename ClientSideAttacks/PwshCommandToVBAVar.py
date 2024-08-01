#!/usr/bin/python3
# a simple python script to convert a powershell oneliner to a VBA var so that it can be tucked into an office macro

command = ""

for i in range(0, len(command), 50):
    print(f"Str = Str + \"{command[i:i+50]}\"")


