Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadlineKeyHandler -Key Shift+Ctrl+a -Function SelectBackwardsLine
Set-PSReadlineKeyHandler -Key Shift+Ctrl+e -Function SelectLine
Set-PSReadlineKeyHandler -Key Shift+Delete -Function Cut
Set-PSReadlineKeyHandler -Key Ctrl+Insert -Function Copy
Set-PSReadlineKeyHandler -Key Shift+UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Shift+DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Shift+Spacebar -Function SelfInsert
Set-PSReadlineOption -BellStyle None

$options = Get-PSReadlineOption
$options.CommandColor = "$([char]0x1b)[35m"
$options.ErrorColor = "$([char]0x1b)[31m"
$options.MemberColor = "$([char]0x1b)[32m"
$options.NumberColor = "$([char]0x1b)[32m"
$options.EmphasisColor = "$([char]0x1b)[34m"
$options.SelectionColor = "$([char]0x1b)[30;106m"
$options.StringColor = "$([char]0x1b)[34m"

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
    "$([char]0x1b)[30m$($ExecutionContext.SessionState.Path.CurrentLocation)> "
}

function curr {
    $dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE")
    $dte.Application.ActiveDocument.FullName
}

function currl {
    $dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE")
    $dte.ActiveDocument.Name + ":" + $dte.ActiveDocument.Selection.CurrentLine
}

function openinvs {
	$dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE")
	$fname = $args[0].split(':')
	$dte.ExecuteCommand("File.OpenFile", $fname[0])
	if ($fname.length -gt 1) {
		$dte.ActiveDocument.Selection.MoveToDisplayColumn($fname[1], 1)
	}
}

function gitlog {
	git log --pretty=format:"%h%x09%an%x09%ai %s" $args
}
