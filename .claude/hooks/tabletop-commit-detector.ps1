param()
$json = [Console]::In.ReadToEnd() | ConvertFrom-Json
$cmd = $json.tool_input.command

if ($cmd -notmatch 'git\s+commit') { exit 0 }
if ($cmd -notmatch 'Tabletop-Magic') { exit 0 }

$flagPath = 'C:\Users\fmaciaal\.claude\hooks\tabletop-vault-flag.txt'
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$commitInfo = & git -C 'C:\Users\fmaciaal\CascadeProjects\Tabletop-Magic' log --oneline -1 2>$null
if ($commitInfo) {
    "$timestamp|$commitInfo" | Out-File $flagPath -Encoding utf8
}
exit 0
