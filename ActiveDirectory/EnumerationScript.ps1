# this first part is assembling the ldap:// link based on the PDC and DN of the domain
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()		# grab the domain object
$PDC = $domainObj.PdcRoleOwner.Name		# store the PdcRoleOwner name
$DN = ([adsi]'').distinguishedName		# grab the DN
$LDAP = "LDAP://$PDC/$DN"

