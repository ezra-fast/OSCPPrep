REM this script will perform cursory enumeration for privilege escalation vectors related to Windows scheduled tasks
REM recipe: find a scheduled task whose action (binary, script, etc.) is writable and is Run As a higher privileged user

REM grab scheduled tasks and their properties; findstr "C:\Users" as needed

REM schtasks /query /fo LIST /v | Select-String -Pattern "C:\\Users" -Context 10, 10
schtasks /query /fo LIST /v


