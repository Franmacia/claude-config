---
description: Instrucciones minimas de Codex para Fran Vault. Mantener corto para ahorrar tokens.
tags: [sistema, codex, instrucciones]
updated: 2026-06-24
---

# Fran Vault — Codex

Segundo cerebro Obsidian de Fran. Recuperación dirigida. Ver [[AI Token Saving Protocol]].

## Al iniciar

Ejecutar `AI/scripts/get-context.ps1 -Agent codex -Domain <auto> -Topic <tema>` para cargar el contexto inicial.
Dominio se detecta por cwd: Tabletop-Magic → tabletop, TELEKOM → telekom, resto → vault.

## Durante la sesión

- No escanear el vault entero. Usar `find-ai-context.ps1` o `get-context.ps1`.
- Extraer tareas del workspace con `extract-handoffs.ps1 -Workspace <ruta>`.
- Leer notas usando `description:` del frontmatter para filtrar.
- Wikilinks solo dentro del mismo dominio.

## Al cerrar

- Actualizar `contexto.md` y crear log en `AI/logs/`.
- Actualizar [[AI Decisions]] / [[AI Handoffs]] si aplica.

## Reglas

- TELEKOM es aislado y confidencial.
- No commitear secretos.
- Para detalles del onboarding completo: [[AI/projects/Agent Onboarding Reference]].
