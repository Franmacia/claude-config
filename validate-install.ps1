#!/usr/bin/env pwsh
# validate-install.ps1 -- Verifica que la instalacion de la config de Claude y el vault estan correctas.

$ErrorActionPreference = "Stop"

$VaultDefaultPath = "C:\Users\$env:USERNAME\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault"
$ConfigDir = Join-Path $env:USERPROFILE ".claude"

$checks = [System.Collections.Generic.List[object]]::new()

function Add-Check {
    param(
        [string]$Name,
        [bool]$Pass,
        [string]$Message,
        [string]$Fix = ""
    )
    $checks.Add([pscustomobject]@{
        Name = $Name
        Pass = $Pass
        Message = $Message
        Fix = $Fix
    })
}

# 1. Repos clonados
$repos = @{
    "Fran-Vault" = "C:\Users\$env:USERNAME\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault"
    "Tabletop-Magic" = "C:\Users\$env:USERNAME\CascadeProjects\Tabletop-Magic"
    "claude-config" = "C:\Users\$env:USERNAME\CascadeProjects\claude-config"
}
foreach ($repo in $repos.GetEnumerator()) {
    $gitDir = Join-Path $repo.Value ".git"
    if (Test-Path -LiteralPath $gitDir) {
        Add-Check -Name "Repo: $($repo.Key)" -Pass $true -Message "Clonado en $($repo.Value)"
    } else {
        Add-Check -Name "Repo: $($repo.Key)" -Pass $false -Message "No encontrado en $($repo.Value)" -Fix "git clone https://github.com/Franmacia/$($repo.Key).git $($repo.Value)"
    }
}

# 2. Config de Claude instalada
$skillsDir = Join-Path $ConfigDir "skills"
$hooksDir = Join-Path $ConfigDir "hooks"
$settingsFile = Join-Path $ConfigDir "settings.json"
if (Test-Path -LiteralPath $skillsDir) {
    Add-Check -Name "Claude skills" -Pass $true -Message "Instalado en $skillsDir"
} else {
    Add-Check -Name "Claude skills" -Pass $false -Message "No encontrado" -Fix "Ejecutar .\install.ps1 desde claude-config"
}
if (Test-Path -LiteralPath $hooksDir) {
    Add-Check -Name "Claude hooks" -Pass $true -Message "Instalado en $hooksDir"
} else {
    Add-Check -Name "Claude hooks" -Pass $false -Message "No encontrado" -Fix "Ejecutar .\install.ps1 desde claude-config"
}
if (Test-Path -LiteralPath $settingsFile) {
    Add-Check -Name "Claude settings.json" -Pass $true -Message "Instalado en $settingsFile"
} else {
    Add-Check -Name "Claude settings.json" -Pass $false -Message "No encontrado" -Fix "Ejecutar .\install.ps1 desde claude-config"
}

# 3. Vault existe
if (Test-Path -LiteralPath $VaultDefaultPath) {
    Add-Check -Name "Vault path" -Pass $true -Message "Encontrado en $VaultDefaultPath"
} else {
    Add-Check -Name "Vault path" -Pass $false -Message "No encontrado" -Fix "Clonar Fran-Vault en la ruta correcta o editar scripts para tu ruta"
}

# 4. Python y dependencias
$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
    Add-Check -Name "Python" -Pass $true -Message "Encontrado: $($python.Source)"
    try {
        $deps = & python -m pip list 2>$null | Out-String
        $required = @("anthropic", "numpy", "scikit-learn", "sqlite-vec")
        foreach ($dep in $required) {
            if ($deps -match "^$dep\s") {
                Add-Check -Name "Dependencia: $dep" -Pass $true -Message "Instalada"
            } else {
                Add-Check -Name "Dependencia: $dep" -Pass $false -Message "No instalada" -Fix "pip install -r claude-config\requirements.txt"
            }
        }
    } catch {
        Add-Check -Name "pip list" -Pass $false -Message "No se pudo ejecutar pip list" -Fix "Reinstalar Python o pip"
    }
} else {
    Add-Check -Name "Python" -Pass $false -Message "No encontrado" -Fix "Instalar Python 3.13+ y asegurar que esta en PATH"
}

# 5. Vault index
$indexDb = Join-Path $VaultDefaultPath "AI\scripts\vault-index.db"
if (Test-Path -LiteralPath $indexDb) {
    Add-Check -Name "Vault index DB" -Pass $true -Message "Encontrado en $indexDb"
} else {
    Add-Check -Name "Vault index DB" -Pass $false -Message "No encontrado" -Fix "Ejecutar vault-index.py desde AI\scripts\ para generarlo"
}

# 6. API key (opcional, solo avisa)
if ($env:ANTHROPIC_API_KEY) {
    Add-Check -Name "ANTHROPIC_API_KEY" -Pass $true -Message "Configurada"
} else {
    Add-Check -Name "ANTHROPIC_API_KEY" -Pass $false -Message "No configurada" -Fix "Necesaria solo para /vault-ingest. Configurar con: [Environment]::SetEnvironmentVariable('ANTHROPIC_API_KEY', 'sk-...', 'User')"
}

# Reporte
Write-Output ""
Write-Output "VALIDACION DE INSTALACION"
Write-Output "========================="
$passed = ($checks | Where-Object { $_.Pass }).Count
$failed = ($checks | Where-Object { -not $_.Pass }).Count
Write-Output "OK: $passed | FALL: $failed | TOTAL: $($checks.Count)"
Write-Output ""
foreach ($check in $checks) {
    $icon = if ($check.Pass) { "OK" } else { "!!" }
    Write-Output "[$icon] $($check.Name)"
    Write-Output "    $($check.Message)"
    if (-not $check.Pass -and $check.Fix) {
        Write-Output "    Fix: $($check.Fix)"
    }
    Write-Output ""
}

if ($failed -eq 0) {
    Write-Output "Instalacion correcta. Reinicia Claude Code para cargar todo."
} else {
    Write-Output "Corregir los fallos marcados con !! antes de usar Claude."
}
