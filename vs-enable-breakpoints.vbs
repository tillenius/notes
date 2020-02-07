Dim dte
Set dte = GetObject(, "VisualStudio.DTE")

for each breakpoint in dte.Debugger.Breakpoints
	if not breakpoint.enabled and breakpoint.tag = "Disabled" then
		breakpoint.enabled = 1
	end if
	breakpoint.tag = ""
next
