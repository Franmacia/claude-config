# vault-briefing.ps1 — Briefing diario desde Fran Vault al iniciar sesión Claude

param(
    [int]$MaxTokens = 3500
)

$VaultPath = "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault"
$Today     = (Get-Date).ToString("yyyy-MM-dd")
$Tomorrow  = (Get-Date).AddDays(1).ToString("yyyy-MM-dd")
$MaxChars = $MaxTokens * 4

function Read-NoteCompact {
    param(
        [string]$Path,
        [int]$MaxChars = 4000,
        [string]$Section = ""
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        return "[no encontrado]"
    }
    $text = [System.IO.File]::ReadAllText($Path)
    # Quitar frontmatter
    if ($text.StartsWith("---")) {
        $end = $text.IndexOf("`n---", 3)
        if ($end -gt 0) {
            $text = $text.Substring($end + 4).TrimStart()
        }
    }
    # Extraer solo una seccion si se pide
    if ($Section) {
        $pattern = "(?m)^## \s*$([regex]::Escape($Section))\s*$"
        if ($text -match $pattern) {
            $start = $text.IndexOf($matches[0])
            $sectionText = $text.Substring($start + $matches[0].Length)
            # Cortar hasta siguiente ##
            $next = $sectionText.IndexOf("`n## ")
            if ($next -gt 0) {
                $sectionText = $sectionText.Substring(0, $next)
            }
            $text = $sectionText.Trim()
        }
    }
    # Simplificar wikilinks y encabezados para ahorrar tokens
    $text = $text -replace '\[\[([^\]|]+)\|?[^\]]*\]\]', '$1'
    $text = $text -replace '^#+ ', ''
    $text = ($text -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }) -join "`n"
    if ($text.Length -gt $MaxChars) {
        $text = $text.Substring(0, $MaxChars) + "`n... [truncado]"
    }
    return $text
}

# ---- Eventos hoy/mañana ----
$AgendaPath = Join-Path $VaultPath "AGENDA"
$events = @()
if (Test-Path $AgendaPath) {
    Get-ChildItem -Path $AgendaPath -Filter "*.md" | ForEach-Object {
        $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -match 'fecha:\s*(\d{4}-\d{2}-\d{2})') {
            $fecha = $Matches[1]
            if ($fecha -eq $Today -or $fecha -eq $Tomorrow) {
                $titulo = if ($content -match 'titulo:\s*(.+)') { $Matches[1].Trim() } else { $_.BaseName }
                $hora   = if ($content -match 'hora:\s*(.+)')   { $Matches[1].Trim() } else { "todo el dia" }
                $label  = if ($fecha -eq $Today) { "HOY" } else { "MANANA" }
                $events += "[$label] $hora - $titulo"
            }
        }
    }
}

# ---- Tasks pendientes (max 10) — solo carpetas activas ----
$tasks = @()
$taskScopes = @("1 Projects", "2 Areas") | ForEach-Object { Join-Path $VaultPath $_ }
$taskScopes | Where-Object { Test-Path $_ } | ForEach-Object {
    Get-ChildItem -Path $_ -Filter "*.md" -Recurse -Depth 3 -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch '\\Templates\\' -and $_.FullName -notmatch '\\.obsidian\\' } |
        ForEach-Object {
            $lines = Get-Content $_.FullName -ErrorAction SilentlyContinue
            foreach ($line in $lines) {
                if ($line -match '^\s*- \[ \] (.+)') {
                    $taskText = ($Matches[1].Trim() -replace '📅\s*\d{4}-\d{2}-\d{2}', '' -replace '⏳\s*\d{4}-\d{2}-\d{2}', '').Trim()
                    $tasks += "[$($_.BaseName)] $taskText"
                }
            }
        }
}

# ---- Dominio activo por cwd ----
$DomainMap = @{
    "C:\Users\fmaciaal\CascadeProjects\Tabletop-Magic" = "tabletop"
    "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault" = "vault"
}
$currentDir = (Get-Location).Path
$activeDomain = $DomainMap[$currentDir]
if (-not $activeDomain) {
    # Fallback por path parcial
    if ($currentDir -like "*Tabletop-Magic*") { $activeDomain = "tabletop" }
    elseif ($currentDir -like "*TELEKOM*") { $activeDomain = "telekom" }
    else { $activeDomain = "vault" }
}

# ---- Contexto inyectado (two-tier memory) ----
# Tier 1: siempre cargado
$contextFiles = @(
    @{ Path = Join-Path $VaultPath "AI\cockpit.md"; Label = "COCKPIT"; MaxChars = 2500 },
    @{ Path = Join-Path $VaultPath "AI\AI Handoffs.md"; Label = "AI HANDOFFS"; MaxChars = 1500; Section = "Activos" }
)

# Tier 2: dominio específico
$domainDecisions = Join-Path $VaultPath "AI\AI Decisions.md"
$domainErrors = Join-Path $VaultPath "AI\errores\$activeDomain.md"
$fallbackErrors = Join-Path $VaultPath "AI\errores\index.md"

$contextFiles += @{ Path = $domainDecisions; Label = "AI DECISIONS"; MaxChars = 2500 }
if (Test-Path -LiteralPath $domainErrors) {
    $contextFiles += @{ Path = $domainErrors; Label = "AI ERRORES ($activeDomain)"; MaxChars = 4000 }
} else {
    $contextFiles += @{ Path = $fallbackErrors; Label = "AI ERRORES"; MaxChars = 1500 }
}

# Repo handoff si el dominio lo justifica
$RepoHandoff = "C:\Users\fmaciaal\CascadeProjects\Tabletop-Magic\HANDOFF.md"
if ($activeDomain -eq "tabletop" -and (Test-Path -LiteralPath $RepoHandoff)) {
    $contextFiles += @{ Path = $RepoHandoff; Label = "REPO HANDOFF"; MaxChars = 4000 }
}

# ---- Output ----
$out = @("=== Vault Briefing ===")

if ($events.Count -gt 0) {
    $out += "AGENDA: " + ($events -join " | ")
} else {
    $out += "AGENDA: sin eventos hoy/manana"
}

if ($tasks.Count -gt 0) {
    $shown = $tasks | Select-Object -First 10
    $out += "TASKS ($($tasks.Count) total): " + ($shown -join " | ")
    if ($tasks.Count -gt 10) { $out += "...y $($tasks.Count - 10) mas" }
} else {
    $out += "TASKS: sin pendientes"
}

foreach ($item in $contextFiles) {
    $max = if ($item.MaxChars) { $item.MaxChars } else { 4000 }
    $section = if ($item.Section) { $item.Section } else { "" }
    $note = Read-NoteCompact -Path $item.Path -MaxChars $max -Section $section
    $out += "`n--- $($item.Label) ---`n$note"
}

$out += "Fecha: $Today"

$context = $out -join "`n"
if ($context.Length -gt $MaxChars) {
    $context = $context.Substring(0, $MaxChars) + "`n... [truncado por token budget]"
}

$output = @{
    continue       = $true
    suppressOutput = $false
    context        = $context
} | ConvertTo-Json -Compress

Write-Output $output
