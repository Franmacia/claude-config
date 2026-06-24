# Claude Config — Fran Second Brain

Este repo contiene la configuración de Claude (hooks, skills, referencias del vault) para replicar el segundo cerebro de Fran en cualquier PC.

## Qué incluye

- `.claude/hooks/vault-briefing.ps1` — inyecta contexto del vault en cada SessionStart.
- `.claude/skills/vault-context/` — skill `/vault-context`.
- `.claude/skills/vault-graph/` — skill `/vault-graph`.
- `.claude/skills/vault-health/` — skill `/vault-health`.
- `.claude/skills/vault-ingest/` — skill `/vault-ingest`.
- `.claude/skills/vault-links/` — skill `/vault-links`.
- `.claude/skills/vault-wrapup/` — skill `/vault-wrapup`.
- `vault-reference/CLAUDE.md` y `AGENTS.md` — referencias de las instrucciones del vault.
- `install.ps1` — instala la configuración en `%USERPROFILE%\.claude\`.
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
2. El hook `vault-briefing.ps1` se ejecutará en cada SessionStart.
3. Usar `/vault-context <tema>` para cargar contexto.
4. Usar `/vault-wrapup` al cerrar sesiones importantes.

## Personalización

Si el vault está en otra ruta, editar:
- `.claude/hooks/vault-briefing.ps1` → `$VaultPath`
- `.claude/skills/*/SKILL.md` → rutas de scripts
- `vault-reference/CLAUDE.md` y `AGENTS.md` → según tu estructura
