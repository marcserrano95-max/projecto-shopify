# Estudio de vídeos para dropshipping

Este repositorio es un estudio de producción de anuncios en vídeo (TikTok / Reels / Shorts)
para productos de dropshipping. El objetivo es replicar la estructura de vídeos virales
con el producto, packaging y avatar propios.

## Idioma
Responde siempre en español.

## Flujo de trabajo
Cada vídeo es un proyecto en `proyectos/<nombre>/` (copia de `proyectos/_plantilla/`):

1. `analista-viral` → analiza el vídeo de referencia (`entrada/`) y escribe `analisis.md`.
2. `guionista-locutor` → escribe `guion.md` y genera la voz en off en `audio/voz.mp3`.
3. `disenador-grafico` → imágenes de producto, avatar, portada y textos en pantalla.
4. `productor-musical` → música de fondo en `audio/musica.mp3`.
5. Generación de clips de vídeo (Higgsfield / Genjutsu) → `clips/01.mp4`, `clips/02.mp4`…
6. `editor-video` → monta todo con `scripts/render.sh` y deja el resultado en `salida/`.

## Reglas
- Antes de cualquier generación que gaste créditos (Higgsfield u otra API), muestra el
  coste y pide confirmación al usuario.
- Formato por defecto: vertical 9:16, 1080x1920, 30 fps, 15–30 segundos.
- No usar la cara ni la voz de personas reales sin permiso, ni logos/marcas de terceros.
  Se replica la estructura y la idea del vídeo viral, no su material protegido.
- Los archivos multimedia pesados no se suben a git (ver `.gitignore`).
