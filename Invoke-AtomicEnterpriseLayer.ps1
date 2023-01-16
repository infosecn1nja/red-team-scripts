Import-Module C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psm1

Set-ExecutionPolicy Bypass -Force

function Invoke-AtomicEnterpriseLayer {
 
    Param(
    [parameter(Mandatory=$true)]
    [String]
    $Group 
    )

    $unixdate = [int][double]::Parse((Get-Date -UFormat %s))

    Start-Transcript  -NoClobber -IncludeInvocationHeader -Path "Atomic-EnterpriseLayer-$unixdate.txt"

    $web = New-Object Net.WebClient
    $mitre = $web.DownloadString("https://attack.mitre.org/groups/$Group/$Group-enterprise-layer.json") 
    $layer = $mitre | ConvertFrom-Json
    $techniques = $layer.techniques.techniqueID

    $name = $layer.name
    $desc = $layer.description

    Write-Output ""
    Write-Output "[+] Name : $name"
    Write-Output "[+] Description : $desc"

    Start-Sleep 3
    Write-Output "[+] Running Atomic Red Team"

    foreach($id in $techniques) {
        Invoke-AtomicTest $id
    }

    Write-Output "[+] Done"
}
