# Jump out if run from a script
if ([Environment]::GetCommandLineArgs().Length -gt 1) {
  return
}

Import-Module oh-my-posh

Set-PoshPrompt -Theme $HOME/.config/oh-my-posh/my-posh-pwsh.json


function invoke-terraforminit { & terraform init -upgrade=true }
function invoke-terraformvalidate { & terraform validate }
function invoke-terraformplan { & terraform plan }
function invoke-terraformapply { & terraform apply --auto-approve }

set-alias tfi invoke-terraforminit
set-alias tfv invoke-terraformvalidate
set-alias tfp invoke-terraformplan
set-alias tfa invoke-terraformapply


# This is an example profile for PSReadLine.
#
# This is roughly what I use so there is some emphasis on emacs bindings,
# but most of these bindings make sense in Windows mode as well.

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Searching for commands with up/down arrow is really handy.  The
# option "moves to end" is useful if you want the cursor at the end
# of the line while cycling through history like it does w/o searching,
# without that option, the cursor will remain at the position it was
# when you used up arrow, which can be useful if you forget the exact
# string you started the search on.
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# This key handler shows the entire or filtered history using Out-GridView. The
# typed text is used as the substring pattern for filtering. A selected command
# is inserted to the command line without invoking. Multiple command selection
# is supported, e.g. selected by Ctrl + Click.
# Set-PSReadLineKeyHandler -Key F7 `
#                          -BriefDescription History `
#                          -LongDescription 'Show command history' `
#                          -ScriptBlock {
#     $pattern = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
#     if ($pattern)
#     {
#         $pattern = [regex]::Escape($pattern)
#     }

#     $history = [System.Collections.ArrayList]@(
#         $last = ''
#         $lines = ''
#         foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineOption).HistorySavePath))
#         {
#             if ($line.EndsWith('`'))
#             {
#                 $line = $line.Substring(0, $line.Length - 1)
#                 $lines = if ($lines)
#                 {
#                     "$lines`n$line"
#                 }
#                 else
#                 {
#                     $line
#                 }
#                 continue
#             }

#             if ($lines)
#             {
#                 $line = "$lines`n$line"
#                 $lines = ''
#             }

#             if (($line -cne $last) -and (!$pattern -or ($line -match $pattern)))
#             {
#                 $last = $line
#                 $line
#             }
#         }
#     )
#     $history.Reverse()

#     $command = $history | Out-GridView -Title History -PassThru
#     if ($command)
#     {
#         [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#         [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
#     }
# }

# In Emacs mode - Tab acts like in bash, but the Windows style completion
# is still useful sometimes, so bind some keys so we can do both
# Set-PSReadLineKeyHandler -Key Ctrl+q -Function TabCompleteNext
# Set-PSReadLineKeyHandler -Key Ctrl+Q -Function TabCompletePrevious

# Clipboard interaction is bound by default in Windows mode, but not Emacs mode.
# Set-PSReadLineKeyHandler -Key Ctrl+C -Function Copy
# Set-PSReadLineKeyHandler -Key Ctrl+v -Function Paste

# CaptureScreen is good for blog posts or email showing a transaction
# of what you did when asking for help or demonstrating a technique.
# Set-PSReadLineKeyHandler -Chord 'Ctrl+d,Ctrl+c' -Function CaptureScreen

# The built-in word movement uses character delimiters, but token based word
# movement is also very useful - these are the bindings you'd use if you
# prefer the token based movements bound to the normal emacs word movement
# key bindings.
# Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
# Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
# Set-PSReadLineKeyHandler -Key Alt+b -Function ShellBackwardWord
# Set-PSReadLineKeyHandler -Key Alt+f -Function ShellForwardWord
# Set-PSReadLineKeyHandler -Key Alt+B -Function SelectShellBackwardWord
# Set-PSReadLineKeyHandler -Key Alt+F -Function SelectShellForwardWord


# Sometimes you enter a command but realize you forgot to do something else first.
# This binding will let you save that command in the history so you can recall it,
# but it doesn't actually execute.  It also clears the line with RevertLine so the
# undo stack is reset - though redo will still reconstruct the command line.
# Set-PSReadLineKeyHandler -Key Alt+w `
#                          -BriefDescription SaveInHistory `
#                          -LongDescription "Save current line in history but do not execute" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $line = $null
#     $cursor = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
#     [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
#     [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
# }

# # Insert text from the clipboard as a here string
# Set-PSReadLineKeyHandler -Key Ctrl+V `
#                          -BriefDescription PasteAsHereString `
#                          -LongDescription "Paste the clipboard text as a here string" `
#                          -ScriptBlock {
#     param($key, $arg)

#     Add-Type -Assembly PresentationCore
#     if ([System.Windows.Clipboard]::ContainsText())
#     {
#         # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
#         $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n","`n").TrimEnd()
#         [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
#     }
#     else
#     {
#         [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
#     }
# }

# # Sometimes you want to get a property of invoke a member on what you've entered so far
# # but you need parens to do that.  This binding will help by putting parens around the current selection,
# # or if nothing is selected, the whole line.
# Set-PSReadLineKeyHandler -Key 'Alt+(' `
#                          -BriefDescription ParenthesizeSelection `
#                          -LongDescription "Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $selectionStart = $null
#     $selectionLength = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

#     $line = $null
#     $cursor = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
#     if ($selectionStart -ne -1)
#     {
#         [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
#         [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
#     }
#     else
#     {
#         [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
#         [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
#     }
# }

# # Each time you press Alt+', this key handler will change the token
# # under or before the cursor.  It will cycle through single quotes, double quotes, or
# # no quotes each time it is invoked.
# Set-PSReadLineKeyHandler -Key "Alt+'" `
#                          -BriefDescription ToggleQuoteArgument `
#                          -LongDescription "Toggle quotes on the argument under the cursor" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $ast = $null
#     $tokens = $null
#     $errors = $null
#     $cursor = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

#     $tokenToChange = $null
#     foreach ($token in $tokens)
#     {
#         $extent = $token.Extent
#         if ($extent.StartOffset -le $cursor -and $extent.EndOffset -ge $cursor)
#         {
#             $tokenToChange = $token

#             # If the cursor is at the end (it's really 1 past the end) of the previous token,
#             # we only want to change the previous token if there is no token under the cursor
#             if ($extent.EndOffset -eq $cursor -and $foreach.MoveNext())
#             {
#                 $nextToken = $foreach.Current
#                 if ($nextToken.Extent.StartOffset -eq $cursor)
#                 {
#                     $tokenToChange = $nextToken
#                 }
#             }
#             break
#         }
#     }

#     if ($tokenToChange -ne $null)
#     {
#         $extent = $tokenToChange.Extent
#         $tokenText = $extent.Text
#         if ($tokenText[0] -eq '"' -and $tokenText[-1] -eq '"')
#         {
#             # Switch to no quotes
#             $replacement = $tokenText.Substring(1, $tokenText.Length - 2)
#         }
#         elseif ($tokenText[0] -eq "'" -and $tokenText[-1] -eq "'")
#         {
#             # Switch to double quotes
#             $replacement = '"' + $tokenText.Substring(1, $tokenText.Length - 2) + '"'
#         }
#         else
#         {
#             # Add single quotes
#             $replacement = "'" + $tokenText + "'"
#         }

#         [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
#             $extent.StartOffset,
#             $tokenText.Length,
#             $replacement)
#     }
# }

# # This example will replace any aliases on the command line with the resolved commands.
# Set-PSReadLineKeyHandler -Key "Alt+%" `
#                          -BriefDescription ExpandAliases `
#                          -LongDescription "Replace all aliases with the full command" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $ast = $null
#     $tokens = $null
#     $errors = $null
#     $cursor = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

#     $startAdjustment = 0
#     foreach ($token in $tokens)
#     {
#         if ($token.TokenFlags -band [TokenFlags]::CommandName)
#         {
#             $alias = $ExecutionContext.InvokeCommand.GetCommand($token.Extent.Text, 'Alias')
#             if ($alias -ne $null)
#             {
#                 $resolvedCommand = $alias.ResolvedCommandName
#                 if ($resolvedCommand -ne $null)
#                 {
#                     $extent = $token.Extent
#                     $length = $extent.EndOffset - $extent.StartOffset
#                     [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
#                         $extent.StartOffset + $startAdjustment,
#                         $length,
#                         $resolvedCommand)

#                     # Our copy of the tokens won't have been updated, so we need to
#                     # adjust by the difference in length
#                     $startAdjustment += ($resolvedCommand.Length - $length)
#                 }
#             }
#         }
#     }
# }


# #
# # Ctrl+Shift+j then type a key to mark the current directory.
# # Ctrj+j then the same key will change back to that directory without
# # needing to type cd and won't change the command line.

# #
# $global:PSReadLineMarks = @{}

# Set-PSReadLineKeyHandler -Key Ctrl+J `
#                          -BriefDescription MarkDirectory `
#                          -LongDescription "Mark the current directory" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $key = [Console]::ReadKey($true)
#     $global:PSReadLineMarks[$key.KeyChar] = $pwd
# }

# Set-PSReadLineKeyHandler -Key Ctrl+j `
#                          -BriefDescription JumpDirectory `
#                          -LongDescription "Goto the marked directory" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $key = [Console]::ReadKey()
#     $dir = $global:PSReadLineMarks[$key.KeyChar]
#     if ($dir)
#     {
#         cd $dir
#         [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
#     }
# }

# Set-PSReadLineKeyHandler -Key Alt+j `
#                          -BriefDescription ShowDirectoryMarks `
#                          -LongDescription "Show the currently marked directories" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $global:PSReadLineMarks.GetEnumerator() | % {
#         [PSCustomObject]@{Key = $_.Key; Dir = $_.Value} } |
#         Format-Table -AutoSize | Out-Host

#     [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
# }

# # Auto correct 'git cmt' to 'git commit'
# Set-PSReadLineOption -CommandValidationHandler {
#     param([CommandAst]$CommandAst)

#     switch ($CommandAst.GetCommandName())
#     {
#         'git' {
#             $gitCmd = $CommandAst.CommandElements[1].Extent
#             switch ($gitCmd.Text)
#             {
#                 'cmt' {
#                     [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
#                         $gitCmd.StartOffset, $gitCmd.EndOffset - $gitCmd.StartOffset, 'commit')
#                 }
#             }
#         }
#     }
# }

# # `ForwardChar` accepts the entire suggestion text when the cursor is at the end of the line.
# # This custom binding makes `RightArrow` behave similarly - accepting the next word instead of the entire suggestion text.
# Set-PSReadLineKeyHandler -Key RightArrow `
#                          -BriefDescription ForwardCharAndAcceptNextSuggestionWord `
#                          -LongDescription "Move cursor one character to the right in the current editing line and accept the next word in suggestion when it's at the end of current editing line" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $line = $null
#     $cursor = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

#     if ($cursor -lt $line.Length) {
#         [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
#     } else {
#         [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
#     }
# }

# # Cycle through arguments on current line and select the text. This makes it easier to quickly change the argument if re-running a previously run command from the history
# # or if using a psreadline predictor. You can also use a digit argument to specify which argument you want to select, i.e. Alt+1, Alt+a selects the first argument
# # on the command line.
# Set-PSReadLineKeyHandler -Key Alt+a `
#                          -BriefDescription SelectCommandArguments `
#                          -LongDescription "Set current selection to next command argument in the command line. Use of digit argument selects argument by position" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $ast = $null
#     $cursor = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$null, [ref]$null, [ref]$cursor)

#     $asts = $ast.FindAll( {
#         $args[0] -is [System.Management.Automation.Language.ExpressionAst] -and
#         $args[0].Parent -is [System.Management.Automation.Language.CommandAst] -and
#         $args[0].Extent.StartOffset -ne $args[0].Parent.Extent.StartOffset
#       }, $true)

#     if ($asts.Count -eq 0) {
#         [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
#         return
#     }

#     $nextAst = $null

#     if ($null -ne $arg) {
#         $nextAst = $asts[$arg - 1]
#     }
#     else {
#         foreach ($ast in $asts) {
#             if ($ast.Extent.StartOffset -ge $cursor) {
#                 $nextAst = $ast
#                 break
#             }
#         }

#         if ($null -eq $nextAst) {
#             $nextAst = $asts[0]
#         }
#     }

#     $startOffsetAdjustment = 0
#     $endOffsetAdjustment = 0

#     if ($nextAst -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
#         $nextAst.StringConstantType -ne [System.Management.Automation.Language.StringConstantType]::BareWord) {
#             $startOffsetAdjustment = 1
#             $endOffsetAdjustment = 2
#     }

#     [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($nextAst.Extent.StartOffset + $startOffsetAdjustment)
#     [Microsoft.PowerShell.PSConsoleReadLine]::SetMark($null, $null)
#     [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar($null, ($nextAst.Extent.EndOffset - $nextAst.Extent.StartOffset) - $endOffsetAdjustment)
# }
