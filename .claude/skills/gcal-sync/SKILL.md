---
name: gcal-sync
description: Sincroniza Google Calendar con la carpeta AGENDA del Fran Vault. Usar cuando el usuario escriba /gcal-sync, "sync calendar", "sincroniza el calendario", "actualiza agenda desde google", "sync gcal".
---

# GCal Sync

Ejecuta el script de sincronizacion bidireccional Google Calendar <-> AGENDA.

## Pasos

1. Ejecutar:

```powershell
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AGENDA\gcal-sync.ps1"
```

2. Mostrar output al usuario en formato:
```
=== GCal Sync ===
Pull: +X nuevos / ~Y actualizados / xZ borrados
Push: W eventos enviados a GCal
=== Completado ===
```

3. Si hay error, mostrarlo y sugerir causa probable.

## Notas

- No requiere browser (OAuth ya guardado en gcal-token.json)
- Si falla con "refresh_token invalid": borrar gcal-token.json y ejecutar manualmente una vez para re-autenticar
