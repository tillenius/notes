Dim dte
Set dte = GetObject(, "VisualStudio.DTE")

for each breakpoint in dte.Debugger.Breakpoints
	if breakpoint.enabled then
		breakpoint.enabled = 0
		breakpoint.tag = "Disabled"
	end if
next
