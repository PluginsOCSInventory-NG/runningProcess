' This script was written to gather information about the running processes for OCS Invetory NG.
' Note, that the process memory is being reported based on the Working Set Size across all operatin systems.
' This is the figure that win2k and xp is reporting in their task managers. Vista, 7 and 2008 are
' by default showing the Private Working Set values in their task managers which is slightly diferent,
' and is not suppoprted by win2k and xp.

'start with detecting the operating system in use
strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

For Each objOperatingSystem in colOperatingSystems
If InStr(objOperatingSystem.version,"5.0.")<>0 Then 																									  'os is windows 2000
	 CompPropNum=16
	 DescrPropNum=17
End If
if InStr(objOperatingSystem.version,"5.1.")<>0 Or InStr(objOperatingSystem.version,"5.2.")<>0 Then		'os is windows XP or 2003
   CompPropNum=35
	 DescrPropNum=36
End If
if InStr(objOperatingSystem.version,"6.0.")<>0 Or InStr(objOperatingSystem.version,"6.1.")<>0 Then 	  'os is windows Vista or 2008 or Windows 7 or 2008 r2
   CompPropNum=33
	 DescrPropNum=34
End If
Next

If CompPropNum=0 Then wscript.quit 2              'operating system not supported, exiting with code 2

strComputer = "."
Set colProcesses = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2").ExecQuery("Select * from Win32_Process")

For Each objProcess in colProcesses
  WSCript.Echo "<RUNNING_PROCESSES>"
  Wscript.echo "  <PROCESSNAME>" & objProcess.Name & "</PROCESSNAME>"
  Wscript.Echo "  <PROCESSID>" & objProcess.ProcessId & "</PROCESSID>"
  Return = objProcess.GetOwner(strNameOfUser)
  Wscript.Echo "  <USERNAME>" & strNameOfUser & "</USERNAME>"
  Wscript.Echo "  <PROCESSMEMORY>" & round(objProcess.workingsetsize/1024) & "</PROCESSMEMORY>"          'return results in kilobytes
  If CompPropNum<>16 then
    Wscript.Echo "  <COMMANDLINE>" & objProcess.commandline & "</COMMANDLINE>"
  else
    'Win 2000 does not support the commandline property, let's use the executable path instead
    Wscript.Echo "  <COMMANDLINE>" & objProcess.executablepath & "</COMMANDLINE>"
  end if

  'extract the file description and company values from the executable
  expath= objProcess.executablePath
  description = ""
  company = ""
  If expath <> "" Then
    path=Left(expath,(InStrRev(expath,"\")))
    fname=Mid(expath,(InStrRev(expath,"\")+1))
    Set shell = CreateObject("Shell.Application")
    Set folder = shell.Namespace(path)
    Set file = folder.ParseName(fname)
    description = folder.GetDetailsOf(file, DescrPropNum)
    company = folder.GetDetailsOf(file, CompPropNum)
  End If
  Wscript.Echo "  <DESCRIPTION>" & description & "</DESCRIPTION>"
  Wscript.Echo "  <COMPANY>" & company & "</COMPANY>"
  WSCript.Echo "</RUNNING_PROCESSES>"
Next