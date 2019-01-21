Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadlineKeyHandler -Key Shift+Ctrl+a -Function SelectBackwardsLine
Set-PSReadlineKeyHandler -Key Shift+Ctrl+e -Function SelectLine
Set-PSReadlineKeyHandler -Key Shift+Delete -Function Cut
Set-PSReadlineKeyHandler -Key Ctrl+Insert -Function Copy
Set-PSReadlineOption -BellStyle None

# Set environment variables for Visual Studio Command Prompt
pushd "$env:VS140COMNTOOLS\..\..\vc\bin\amd64"
cmd /c "vcvars64.bat & set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("=")
    set-item -force -path "ENV:\$($v[0])" -value "$($v[1])"
  }
}
popd

function prompt {
    "$($ExecutionContext.SessionState.Path.CurrentLocation)> "
}

function curr {
    $dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE.15.0")
    $dte.Application.ActiveDocument.FullName
}

function currl {
    $dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE.15.0")
    $dte.ActiveDocument.Name + ":" + $dte.ActiveDocument.Selection.CurrentLine
}

function openinvs {
	$dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE.15.0")
	$fname = $args[0].split(':')
	$dte.ExecuteCommand("File.OpenFile", $fname[0])
	if ($fname.length -gt 1) {
		$dte.ActiveDocument.Selection.MoveToDisplayColumn($fname[1], 1)
	}
}

function gitlog {
	git log --pretty=format:"%h%x09%an%x09%ai %s" $args
}
