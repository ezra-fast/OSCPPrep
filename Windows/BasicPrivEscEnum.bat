REM This small batch script gathers inital information for Windows privilege escalation
REM Always enumerate users, their groups, and other groups on the system
REM Always enumerate for user files (pdf, doc, docx, txt, ini, xls, xlxs, ppt, pptx, etc.)
whoami
whoami /groups
powershell -c "Get-LocalUser"
REM net user <username> --> can also be used to zero in on a given user
powershell -c "Get-LocalGroup"
REM powershell -c "Get-LocalGroupMember <group-name>"   --> call this on different groups to verify membership
systeminfo
ipconfig /all
route print
netstat -ano
REM removing "| select displayname from the following commands shows all information"
powershell -c "Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | select displayname" REM enumerating installed 32 bit applications
powershell -c "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | select displayname" REM enumerating installed 64 bit applications
REM also enumerate C:\Program Files\ for both architectures and any readable Downloads folders
powershell -c "Get-Process"
REM powershell.exe -c "Get-Process <process-name> | Format-List *"  --> this command will list all information on the named process

REM Use a variation of the following command to:
REM - enumerate configuration files and other password related files for each piece of installed software
REM - enumerate the home folder(s) of each user on the system (net user) for personal documents

powershell -c "Get-ChildItem -Path C:\Users\ -Include *.txt,*.pdf,*.xls,*.xlsx,*.doc,*.docx -File -Recurse -ErrorAction SilentlyContinue"

REM finding secrets via PS history and logging solutions
powershell -c "Get-History"
powershell -c "(Get-PSReadlineOption).HistorySavePath"
REM enumerating for PS Transcription files
powershell -c "Get-ChildItem -Path C:\Users\ -Include *transcript*.txt -File -Recurse -ErrorAction SilentlyContinue"
powershell -c "Get-ChildItem -Path C:\Users\ -Include *transcript.txt -File -Recurse -ErrorAction SilentlyContinue"
powershell -c "Get-ChildItem -Path C:\Users\ -Include transcript*.txt -File -Recurse -ErrorAction SilentlyContinue"

REM enumerating for escalation via Windows services
REM powershell -c "Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.State -like 'Running'}"
REM icacls <service-binary-path>

echo "Still looking? try WinPEAS, PowerUp, JAWS, and SeatBelt."
echo "Parse text output files with: Get-Content SBOutput.txt | Select-String -Pattern 'InstalledProduct' -Context 0, 60"
