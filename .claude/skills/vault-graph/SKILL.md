---
name: vault-graph
description: >
  Ejecuta el grafo del vault y propone conexiones. Uso: /vault-graph
---

# Vault Graph Skill

## Uso

`/vault-graph [scope]`

## Cuando usar

- Cuando quieras entender cómo están conectadas las notas.
- Para detectar notas huérfanas.
- Para encontrar hubs de conocimiento.

## Pasos

1. Ejecutar el graph extractor:
   ```powershell
   & "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AI\scripts\vault-graph.ps1" `
     -Scope AI
   ```

2. Leer el informe generado:
   `AI/scripts/reports/vault-graph-YYYY-MM-DD.md`

3. Resumir:
   - Notas huérfanas.
   - Sugerencias de conexión.
   - Top hubs.

4. Proponer acciones:
   - Añadir wikilinks donde tenga sentido.
   - Convertir notas huérfanas en hubs o enlazarlas.

## Reglas

- No aplicar sugerencias automáticamente sin confirmar con el usuario.
- No modificar reportes generados.
- Preferir conexiones dentro del mismo dominio.
