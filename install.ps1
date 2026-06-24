#!/usr/bin/env pwsh
# install.ps1 -- Instala la configuracion de Claude en %USERPROFILE%\.claude

$ErrorActionPreference = "Stop"

$source = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $env:USERPROFILE ".claude"

if (-not (Test-Path -LiteralPath $target)) {
    New-Item -ItemType Directory -Force -Path $target | Out-Null
}

# Copiar skills
$skillsSource = Join-Path $source ".claude\skills"
$skillsTarget = Join-Path $target "skills"
if (Test-Path -LiteralPath $skillsSource) {
    New-Item -ItemType Directory -Force -Path $skillsTarget | Out-Null
    Get-ChildItem -LiteralPath $skillsSource -Directory | ForEach-Object {
        $dest = Join-Path $skillsTarget $_.Name
        Copy-Item -LiteralPath $_.FullName -Destination $dest -Recurse -Force
        Write-Output "Instalado skill: $($_.Name)"
    }
}

# Copiar hooks
$hooksSource = Join-Path $source ".claude\hooks"
$hooksTarget = Join-Path $target "hooks"
if (Test-Path -LiteralPath $hooksSource) {
    New-Item -ItemType Directory -Force -Path $hooksTarget | Out-Null
    Get-ChildItem -LiteralPath $hooksSource -File | ForEach-Object {
        $dest = Join-Path $hooksTarget $_.Name
        Copy-Item -LiteralPath $_.FullName -Destination $dest -Force
        Write-Output "Instalado hook: $($_.Name)"
    }
}

# Copiar settings.json
$settingsSource = Join-Path $source ".claude\settings.json"
$settingsTarget = Join-Path $target "settings.json"
if (Test-Path -LiteralPath $settingsSource) {
    Copy-Item -LiteralPath $settingsSource -Destination $settingsTarget -Force
    Write-Output "Instalado settings.json"
}

Write-Output ""
Write-Output "Instalacion completada en $target"
Write-Output "Reinicia Claude Code para cargar hooks y skills."
Write-Output "Ejecuta .\validate-install.ps1 para verificar que todo esta correcto."
