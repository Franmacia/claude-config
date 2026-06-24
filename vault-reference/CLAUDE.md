# Fran Vault

Segundo cerebro Obsidian de Fran. Recuperación dirigida — nunca escanear vault entero.

## Navegación
1. `00 MOC.md` → MOC del área → nota concreta.
2. Usar `description:` del frontmatter para filtrar antes de abrir nota entera.

## Estructura
- `1 Projects/` `2 Areas/` `3 Resources/` `4 Archive/` — patrón PARA.
- `AGENDA/` — infraestructura viva (scripts + eventos `2026-*.md`). **No mover ni renombrar: rompe scripts.**
- `TELEKOM/` — isla aislada, confidencial NTT/Telekom.
- Dominios separados: TELEKOM ⊥ MTG/hobby ⊥ sistema. Sin enlaces cruzados.

## Notas
- Frontmatter: `description:` (1 línea para filtrar), `tags:`, `status:`, `updated:`.
- `[[wikilink]]` solo dentro del mismo dominio.

## Protocolo de sesión
- `contexto.md` ya viene inyectado por vault-briefing hook — no leerlo manualmente salvo fallo del hook.
- Al terminar sesión: actualizar `contexto.md` + log en `AI/logs/YYYY-MM-DD-tema.md`.
- Para sesiones Codex/Claude: seguir [[AI Token Saving Protocol]], actualizar [[AI Decisions]] y [[AI Handoffs]] cuando aplique.

## Git
- `.gitignore` excluye: `TELEKOM/`, `AGENDA/gcal-token.json`, `AGENDA/gcal-sync.ps1`, plugin `google-calendar/data.json`.
- Nunca commitear secretos/credenciales.
