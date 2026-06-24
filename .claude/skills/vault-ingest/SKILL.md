---
name: vault-ingest
description: >
  Ingesta una URL, PDF o texto en Fran Vault: extrae ideas, entidades y decisiones,
  crea nota enlazada y propone conexiones. Uso: /vault-ingest
---

# Vault Ingest Skill

## Cuándo usar

Cuando encuentras una URL, recibes un PDF/transcript, o quieras guardar una idea/lección del exterior en el vault.

## Comando

`/vault-ingest [fuente]`

## Pasos

1. **Obtener la fuente**:
   - Si el usuario pasa una URL publica, usar `AI/scripts/vault-ingest.py`:
     ```powershell
     $env:ANTHROPIC_API_KEY = "sk-..."
     python "AI/scripts/vault-ingest.py" --root "<vault>" --url "<url>" --domain <vault|tabletop|telekom> --title "<titulo>" --tags "ingest, ..."
     ```
   - Si el usuario pega texto directo, usarlo tal cual y resumirlo con Claude en la conversacion.
   - Si pasa un archivo local, leerlo con herramientas disponibles.

2. **Procesar con Claude**:
   - El script `vault-ingest.py` descarga el HTML, extrae texto, y llama a Claude API para obtener:
     - Resumen en 3-5 bullets.
     - Entidades: personas, proyectos, conceptos, herramientas.
     - Decisiones / lecciones aprendidas.
     - Wikilinks propuestos.

3. **Crear nota en el vault**:
   - Ubicacion: `0 Inbox/`.
   - Frontmatter: `description`, `tags`, `type: ingest`, `source`, `domain`, `status: activo`, `updated`.

4. **Sugerir conexiones**:
   - Revisar notas existentes que mencionen las mismas entidades.
   - Añadir wikilinks bidireccionales si el usuario confirma.

5. **Reindexar**:
   - Ejecutar `python AI/scripts/vault-index.py --root <vault> --scope AI --index`.

6. **Commit**:
   - `git add` de la nueva nota.
   - `git commit -m "ingest: <tema>"`.

## Reglas

- No descargar URLs automáticamente sin confirmación del usuario.
- Si la fuente es un artículo de trabajo, usar dominio apropiado (`telekom`, `tabletop`, `vault`).
- No ingestar contenido con secretos, API keys ni datos personales de terceros.
- Preferir notas pequeñas con enlaces, no monolitos.

## Ejemplo de salida

```markdown
---
description: Resumen de articulo sobre semantic search local.
tags: [ai, ingest, semantic-search]
type: ingest
source: https://example.com/article
domain: vault
status: activo
updated: 2026-06-24
---

# Ingest: Semantic Search Local

## Resumen

- sqlite-vec permite guardar vectores en SQLite sin servidor.
- TF-IDF + SVD es una alternativa ligera a embeddings neuronales.
- Para vaults personales, 384 dimensiones suele ser suficiente.

## Entidades

- sqlite-vec
- TF-IDF
- SVD

## Decisiones

- Usar TF-IDF en lugar de sentence-transformers para evitar dependencia de PyTorch.

## Wikilinks propuestos

- [[AI/projects/Second Brain Research]]
- [[AI/scripts/vault-index.py]]

## Fuente

<https://example.com/article>
```
