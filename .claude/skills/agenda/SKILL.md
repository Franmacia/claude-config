---
name: agenda
description: Agenda y recordatorios personales. Use /agenda.
---

# Agenda Personal — Fran Vault

Carpeta AGENDA: `C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AGENDA\`

Script notificaciones: `<carpeta>\agenda-notify.ps1`

## Formato de ficheros

Cada evento es un fichero `.md` con este frontmatter:

```
---
fecha: YYYY-MM-DD
hora: HH:MM        (opcional)
titulo: Texto del evento
tipo: reunion|tarea|recordatorio|personal
prioridad: alta|media|baja
---
Descripcion opcional (puede estar vacia)
```

Nombre del fichero: `YYYY-MM-DD-titulo-en-kebab-case.md`
Ejemplo: `2026-06-20-reunion-kick-off.md`

---

## MODO READ — Ver agenda

Activa con: `/agenda`, "qué tengo", "agenda", "mis recordatorios", "esta semana".

**Pasos:**
1. Listar todos `.md` en la carpeta AGENDA (excluir `.ps1` y ficheros sin fecha válida)
2. Parsear frontmatter de cada fichero
3. Filtrar: hoy + próximos 7 días
4. Agrupar por día y mostrar

**Formato de salida** (siempre en español, caveman-style):

```
=== AGENDA (15/06 - 22/06) ===

HOY (15/06)
  [!] 10:00  Reunion kick-off  [reunion]
      14:00  Revisar PR de Angel  [tarea]

MANANA (16/06)
  [!]        Entregar informe mensual  [tarea]

20/06
             Dentista  [personal]

Sin eventos para el resto de la semana.
```

- `[!]` = prioridad alta
- Sin hora → espacios en blanco en columna de hora
- Ningún evento en todo el rango → "Sin eventos proximos."
- Incluir siempre el rango de fechas en el header

---

## MODO ADD — Añadir evento

Activa con: "recuérdame", "añade", "tengo X el [fecha]", "apunta que", "no se me olvide", "agenda X para".

**Pasos:**
1. Extraer del lenguaje natural del usuario:
   - **fecha**: interpretar expresiones como "el viernes", "mañana", "pasado mañana", "el 20", "el 20 de junio", "el lunes que viene" → convertir a `YYYY-MM-DD` relativo a hoy
   - **hora**: si mencionada ("a las 10", "a las 15:30") → `HH:MM`; si no, omitir campo
   - **titulo**: lo que hay que recordar, en texto natural limpio
   - **tipo**: inferir del contexto — "reunión/llamada/meeting" → `reunion`; "entregar/informe/PR" → `tarea`; "médico/dentista/gym/cena" → `personal`; resto → `recordatorio`
   - **prioridad**: "urgente"/"importante"/"crítico" → `alta`; "cuando pueda"/"si hay tiempo" → `baja`; resto → `media`

2. Construir nombre de fichero: `YYYY-MM-DD-titulo-kebab.md`
   - Kebab: minúsculas, espacios→guiones, eliminar acentos y caracteres especiales
   - Ejemplo: "Reunión con Ángel" → `reunion-con-angel`

3. Crear el fichero en la carpeta AGENDA

4. Confirmar al usuario: "Creado: [titulo] para [fecha DD/MM][ a las HH:MM]"

Si hay ambigüedad en la fecha (ej. "el 5" sin mes claro), preguntar antes de crear.

---

## MODO NOTIFY — Notificación toast Windows

Activa con: "notificar ahora", "manda notificacion", "avísame", "manda el toast".

Ejecutar:
```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AGENDA\agenda-notify.ps1" -DiasAnticipacion 1
```

Confirmar al usuario el resultado del script.

## MODO POPUP — Post-it visual en pantalla

Activa con: "popup", "post-it", "muestra popup", "abre popup", "ventana agenda".

Ejecutar en background (no bloquea):
```powershell
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AGENDA\agenda-popup.ps1`" -DiasAnticipacion 7" -WindowStyle Hidden
```

Post-it amarillo aparece esquina superior derecha. Click para cerrar, drag para mover.

---

## Reglas generales

- **Solo** leer/escribir en la carpeta AGENDA. No tocar otros ficheros del Vault.
- Responder siempre en **español**, estilo **caveman** (terse, fragmentos OK, sin artículos).
- Ignorar silenciosamente ficheros sin frontmatter válido (sin campo `fecha` o fecha mal formateada).
- Al crear ficheros: usar `Write` con encoding UTF-8, nunca CRLF forzado.
- Si no hay eventos en el rango, decirlo claramente en una línea.
