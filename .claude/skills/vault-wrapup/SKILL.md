---
name: vault-wrapup
description: >
  Cierra una sesión de trabajo en Fran Vault: extrae decisiones, genera log, actualiza handoffs y cockpit.
  Uso: /vault-wrapup
---

# Vault Wrapup Skill

## Cuándo usar

Al final de cualquier sesión de trabajo importante en Fran Vault o en repos asociados (Tabletop-Magic, TELEKOM, etc.).

## Comando

`/vault-wrapup`

## Pasos

1. **Preguntar al usuario** (si no lo ha proporcionado):
   - Tema de la sesión
   - Resumen de lo hecho
   - Decisiones estables (si las hay)
   - Siguiente paso / pendientes
   - Dominio afectado: `vault`, `tabletop`, `telekom`, `cross-domain`

2. **Generar log** ejecutando:
   ```powershell
   & "C:\Users\fmaciaal\OneDrive - NTT DATA EMEAL\Documentos\Fran Vault\AI\scripts\close-ai-session.ps1" `
     -Topic "<tema>" `
     -Agent "claude" `
     -Project "<proyecto>" `
     -Summary "<resumen>" `
     -Decision "<decisiones>" `
     -Next "<siguiente paso>"
   ```

3. **Actualizar memoria operativa si aplica**:
   - Si hay decisiones estables: añadir a `AI/AI Decisions.md` bajo la fecha actual, en la sección del dominio afectado.
   - Si quedan pendientes transferibles: añadir a `AI/AI Handoffs.md` bajo `## Activos`.
   - Si cambia el foco global o blockers: actualizar `AI/cockpit.md`.
   - Si la sesión es de Tabletop Magic: actualizar también `HANDOFF.md` del repo y `1 Projects/Tabletop Magic.md`.

4. **Commit en el vault**:
   - Staging selectivo: solo ficheros tocados por el cierre.
   - Mensaje: `docs: log sesion <tema>` o `feat: ...` según el cambio.

5. **Responder al usuario** con:
   - Log creado
   - Notas actualizadas
   - Commits realizados
   - Próximo paso recomendado

## Gestión de sesión (evitar bucles y contexto podrido)

Antes de cerrar, evaluar el estado de la conversación:

- Si la sesión fue **larga o con muchas correcciones**: recomendar `/compact <tema>` para resumir el contexto.
- Si hay **mensajes irrelevantes o tangentes**: recomendar `/clear` antes de la siguiente tarea.
- Si Claude entró en un **bucle o error repetido**: recomendar `/rewind` a un checkpoint anterior.
- Si la siguiente tarea es **independiente**: recomendar cerrar esta conversación y abrir una nueva.

Añadir al final del wrapup una nota breve:
> **Sugerencia de gestión de sesión**: usar `/clear` o `/compact` si la próxima tarea no depende de esta conversación.

## Reglas

- No actualizar `AI/AI Decisions.md` con decisiones triviales o temporales.
- No crear handoffs para tareas que el usuario va a hacer él mismo en la próxima sesión.
- Mantener dominios aislados: no mezclar pendientes de TELEKOM con los de Tabletop Magic.
- Si no hay decisiones ni handoffs nuevos, solo generar el log.
- No generar el log si la sesión terminó en bucle sin valor añadido; en su lugar, recomendar `/rewind` y reintentar.
