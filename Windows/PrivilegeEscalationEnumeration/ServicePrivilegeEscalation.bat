REM this script is meant to enumerate for privilege escalation vectors related to Windows Services
REM vectors include writable service binaries, hijackable service DLLs (or abusing the DLL search order), and unquoted service paths

REM services running outside of C:\Windows\System32 are normally user installed 
REM service binaries with 'F' permissions for the current user are writable
REM Get-CimInstance -ClassName win32_service | Select Name,StartMode | Where-Object {$_.Name -like '<service-name>'}        grab the Startup Type of the service if it can't be restarted

REM get information about the service:
REM Get-Service <service-name> | Format-List *

REM running services

powershell -c "Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.State -like 'Running'}"
REM icacls <service-binary-path>

REM look for non-system32 running services:
REM Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.State -like 'Running'} | Select-String -Pattern "C:\\Windows\\system32" -NotMatch

REM running and stopped services

REM powershell -c "Get-CimInstance -ClassName win32_service | Select Name,State,PathName"

REM unquoted service paths for services outside of C:\Windows\; does not check for spaces in binary paths

wmic service get name,pathname |  findstr /i /v "C:\Windows\\" | findstr /i /v """


