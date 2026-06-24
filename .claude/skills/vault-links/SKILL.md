---
name: vault-links
description: >
  Sugiere wikilinks faltantes entre notas del vault. Uso: /vault-links
---

# Vault Links Skill

## Uso

`/vault-links [scope]`

## Cuando usar

- Cuando el vault tenga muchas notas huérfanas.
- Para descubrir conexiones entre notas del mismo dominio.
- Tras ingestar nuevas notas.

## Pasos

1. Asegurar que el índice semántico está actualizado:
   ```powershell
   python "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AI\scripts\vault-index.py" `
     --root "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault" `
     --scope AI --index
   ```

2. Ejecutar el sugeridor:
   ```powershell
   & "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AI\scripts\vault-link-suggest.ps1" `
     -Scope AI -TopK 20
   ```

3. Leer el informe:
   `AI/scripts/reports/link-suggestions-YYYY-MM-DD.md`

4. Presentar las mejores sugerencias al usuario con razones.

5. Aplicar solo las confirmadas.

## Reglas

- Nunca usar `-Apply` sin confirmación.
- Preferir sugerencias con múltiples razones (same folder + semantic + mention).
- No sugerir links a reportes generados.
