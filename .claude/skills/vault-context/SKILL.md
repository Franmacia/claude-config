---
name: vault-context
description: >
  Carga contexto del segundo cerebro para el tema actual. Uso: /vault-context [tema]
---

# Vault Context Skill

## Uso

`/vault-context [tema]`

## Cuando usar

- Al empezar una tarea nueva y necesitar contexto del vault.
- Cuando el tema sea amplio y quieras saber qué notas son relevantes.
- Si no estás seguro de qué decisiones, errores o handoffs aplican.

## Pasos

1. Detectar o preguntar el dominio:
   - cwd contiene `Tabletop-Magic` → tabletop.
   - cwd contiene `TELEKOM` → telekom.
   - resto → vault.

2. Ejecutar el context router:
   ```powershell
   & "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AI\scripts\get-context.ps1" `
     -Agent claude -Domain <auto> -Topic "<tema>" -Limit 5
   ```

3. Resumir al usuario:
   - Foco actual según cockpit.
   - Handoffs activos relacionados.
   - Decisiones y errores relevantes.
   - Notas similares encontradas.

4. Sugerir próximo paso concreto.

## Ejemplo

Usuario: `/vault-context action-orchestrator`

Claude ejecuta `get-context.ps1 -Domain tabletop -Topic "action-orchestrator"` y devuelve:
- Cockpit: migrar rules-engine y ai-rival a action-orchestrator.
- Decisiones: action-orchestrator es la única fuente de acciones legales.
- Errores: engineResolveTop, ETB effects, tokens no hidratables.
- Handoffs: M8 Codex pendiente.
- Notas relacionadas: TableTop Magic - Agent Graph, logs recientes.
