# Claude Config — Fran Second Brain

Este repo contiene la configuración de Claude (hooks, skills, referencias del vault) para replicar el segundo cerebro de Fran en cualquier PC.

## Qué incluye

- `.claude/settings.json` — configuración de hooks y plugins de Claude.
- `.claude/hooks/` — todos los hooks (caveman, session health, vault-briefing, etc.).
- `.claude/skills/` — todos los skills (vault-*, caveman, diagnose, etc.).
- `vault-reference/CLAUDE.md` y `AGENTS.md` — referencias de las instrucciones del vault.
- `install.ps1` — instala la configuración en `%USERPROFILE%\.claude\`.
- `validate-install.ps1` — verifica que todo esté correctamente instalado.
- `requirements.txt` — dependencias Python del second brain.

## Instalación rápida

```powershell
git clone https://github.com/Franmacia/claude-config.git
.\install.ps1
```

## Requisitos

- Python 3.13+
- PowerShell 7+
- Fran Vault clonado en `C:\Users\<usuario>\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault` (o ajustar rutas en `vault-briefing.ps1` y skills).

## Dependencias Python

```powershell
pip install -r requirements.txt
```

## Post-instalación

1. Abrir Claude Code en el vault como workspace.
2. Ejecutar `\.validate-install.ps1` para verificar que todo esté correcto.
3. El hook `vault-briefing.ps1` se ejecutará en cada SessionStart.
4. Usar `/vault-context <tema>` para cargar contexto.
5. Usar `/vault-wrapup` al cerrar sesiones importantes.

## Personalización

Si el vault está en otra ruta, editar:
- `.claude/hooks/vault-briefing.ps1` → `$VaultPath`
- `.claude/skills/*/SKILL.md` → rutas de scripts
- `vault-reference/CLAUDE.md` y `AGENTS.md` → según tu estructura
