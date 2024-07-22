# Import-Module .\script.ps1; 
#
# Examples:
# 	- LDAPSearch -LDAPQuery "samAccountType=805306368"		(enumerate users)
# 	- LDAPSearch -LDAPQuery "objectclass=group"			(enumerate groups)
#
# Enumerating all groups and their user members:
# foreach ($group in $(LDAPSearch -LDAPQuery "(objectCategory=group)")) {
# $group.properties | select {$_.cn}, {$member}
# }
#
# Enumerating all members in a specific group
# $group = LDAPSearch -LDAPQuery "(&(objectCategory=group)(cn<group-name>*))"
# $group.properties.member

function LDAPSearch {		# this function queries AD based on parameter 1, which should be a search filter such as: "samAccountType=805306368" or "name=<username>"
	param (
		[string]$LDAPQuery
	)
	
	$PDC = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.Name
	$DistinguishedName = ([adsi]'').distinguishedName

	$DirectoryEntry = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$PDC/$DistinguishedName")
	$DirectorySearcher = New-Object System.DirectoryServices.DirectorySearcher($DirectoryEntry, $LDAPQuery)

	return $DirectorySearcher.FindAll()
}





## This is where the script originally started; comment in from here if needed
## this first part is assembling the ldap:// link based on the PDC and DN of the domain
#$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()		# grab the domain object
#$PDC = $domainObj.PdcRoleOwner.Name		# store the PdcRoleOwner name
#$DN = ([adsi]'').distinguishedName		# grab the DN
#$LDAP = "LDAP://$PDC/$DN"

## encapsulating the LDAP path
#$direntry = New-Object System.DirectoryServices.DirectoryEntry($LDAP)

#$dirsearcher = New-Object System.DirectoryServices.DirectorySearcher($direntry)

#$dirsearcher.filter ="samAccountType=805306368"		# users
##$dirsearcher.filter ="name=<username>"		# filter by username

## using the LDAP path to search for all objects from the start of the AD hierarchy
##$dirsearcher.FindAll()		# grab all objects in the domain

#$result = $dirsearcher.FindAll()

## iterate through the filtered results and print each property
#Foreach($obj in $result)
#{
	#Foreach($prop in $obj.Properties)
	#{
		#$prop
		##$prop.memberof			# only print groups <user> is a member of 
	#}

	#Write-Host "--------------------"
#}


