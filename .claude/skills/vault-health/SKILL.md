---
name: vault-health
description: >
  Ejecuta el health check del vault y propone correcciones. Uso: /vault-health
---

# Vault Health Skill

## Uso

`/vault-health [scope]`

## Cuando usar

- Antes de cerrar una sesión importante.
- Cuando sospeches que hay wikilinks rotos o notas mal formadas.
- Periódicamente para mantener el vault limpio.

## Pasos

1. Ejecutar el health check:
   ```powershell
   & "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AI\scripts\vault-health.ps1" `
     -Scope AI -Full
   ```

   Scope por defecto: `AI`. Puedes cambiar a `1 Projects`, `2 Areas`, etc.

2. Interpretar los warnings:
   - **broken wikilink**: corregir o eliminar el link.
   - **ambiguous wikilink**: usar ruta completa.
   - **missing property**: añadir frontmatter.
   - **orphan note**: evaluar si es un hub o necesita enlaces.
   - **not indexed**: añadir el log a `AI/logs/index.md`.

3. Proponer y aplicar correcciones mínimas.

4. Ejecutar de nuevo para verificar.

## Reglas

- No corregir warnings de `AGENTS.md` o `CLAUDE.md` siendo huérfanos: son hubs intencionales.
- No tocar notas de `TELEKOM/` desde el health check.
- Si hay muchos warnings, priorizar links rotos y notas sin `description`.
