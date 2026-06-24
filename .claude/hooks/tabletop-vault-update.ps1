param()
$flagPath = 'C:\Users\fmaciaal\.claude\hooks\tabletop-vault-flag.txt'
if (-not (Test-Path $flagPath)) { exit 0 }

$raw = (Get-Content $flagPath -Raw -ErrorAction SilentlyContinue).Trim()
$parts = $raw -split '\|', 2
$ts = $null
try { $ts = [datetime]::ParseExact($parts[0].Trim(), 'yyyy-MM-dd HH:mm:ss', $null) } catch { }

# Flag caduca despues de 60 min — evita rewakes rancios
if ($null -eq $ts -or ([datetime]::Now - $ts).TotalMinutes -gt 60) {
    Remove-Item $flagPath -Force
    exit 0
}

$commitInfo = if ($parts.Count -gt 1) { $parts[1].Trim() } else { 'commit desconocido' }
Remove-Item $flagPath -Force
Write-Output "TABLETOP_VAULT_PENDIENTE: Hay commits en Tabletop-Magic sin reflejar en Obsidian. Ultimo commit: $commitInfo. Actualiza '1 Projects/Tabletop Magic.md' y 'AI/AI Handoffs.md' leyendo HANDOFF.md del repo, y haz commit en el vault."
exit 2
