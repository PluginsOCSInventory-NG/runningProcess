'----------------------------------------------------------
' Plugin for OCS Inventory NG 2.x
' Script :		Retrieve running processes
' Version :		2.00
' Date :		10/02/2018
' Author :		Stéphane PAUTREL (acb78.com)
'----------------------------------------------------------
' OS checked [X] on	32b	64b	(Professionnal edition)
'	Windows XP		[X]
'	Windows Vista	[X]	[X]
'	Windows 7		[X]	[X]
'	Windows 8.1		[X]	[X]	
'	Windows 10		[X]	[X]
'	Windows 2k8R2		[X]
'	Windows 2k12R2		[X]
'	Windows 2k16		[X]
' ---------------------------------------------------------
' NOTE : No checked on Windows 8
' ---------------------------------------------------------
On Error Resume Next

Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")
Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

For Each objOperatingSystem in colOperatingSystems
	If InStr(objOperatingSystem.version,"5.1.")<>0 Or InStr(objOperatingSystem.version,"5.2.")<>0 Then		'os is windows XP or 2003
		CompPropNum=35
		DescrPropNum=36
	Else
		CompPropNum=33
		DescrPropNum=34
	End If
Next

Set colProcesses = objWMIService.ExecQuery( "SELECT * FROM Win32_Process",,48)

For Each objProcess in colProcesses
	Result ="<RUNNINGPROCESS>" & VbCrLf &_
			"<PROCESSNAME>" & objProcess.Name & "</PROCESSNAME>" & VbCrLf &_
			"<PROCESSID>" & objProcess.ProcessId & "</PROCESSID>" & VbCrLf

	Return = objProcess.GetOwner(strNameOfUser)
	Result = Result & "<USERNAME>" & strNameOfUser & "</USERNAME>" & VbCrLf &_
					"<PROCESSMEMORY>" & round(objProcess.workingsetsize/1024) & "</PROCESSMEMORY>" & VbCrLf 'return results in kilobytes

	Result = Result & "<COMMANDLINE>" & objProcess.commandline & "</COMMANDLINE>" & VbCrLf

	'extract the file description and company values from the executable
	expath = objProcess.executablePath
	company = ""

	If expath <> "" Then
		path=Left(expath,(InStrRev(expath,"\")))
		fname=Mid(expath,(InStrRev(expath,"\")+1))
		Set shell = CreateObject("Shell.Application")
		Set folder = shell.Namespace(path)
		Set file = folder.ParseName(fname)
		company = folder.GetDetailsOf(file, CompPropNum)
	End If

	Result = Result &	"<DESCRIPTION>" & objProcess.description & "</DESCRIPTION>" & VbCrLf &_
						"<COMPANY>" & company & "</COMPANY>" & VbCrLf &_
						"</RUNNINGPROCESS>"
	WScript.echo Result
Next