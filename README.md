# Estudio de vídeos para dropshipping con Claude Code

Replica la estructura de vídeos virales con tu producto, tu packaging y tu avatar,
usando Claude Code en tu ordenador con un equipo de agentes:

| Agente | Qué hace |
|---|---|
| `analista-viral` | Analiza el vídeo de referencia escena por escena |
| `guionista-locutor` | Escribe el guion, los subtítulos y genera la voz en off |
| `disenador-grafico` | Imágenes de producto, avatar, portada y estilo de textos |
| `productor-musical` | Música de fondo y efectos de sonido |
| `editor-video` | Monta y renderiza el vídeo final 9:16 con ffmpeg |

La generación de imágenes, vídeo, voz y música la hace **Higgsfield** (consume tus
créditos). Claude coordina, escribe, analiza y monta.

---

## Paso 1 — Instalar lo necesario

### En Mac
1. Abre la app **Terminal**.
2. Instala Homebrew si no lo tienes (https://brew.sh) y después:
   ```bash
   brew install git ffmpeg
   ```
3. Instala Claude Code:
   ```bash
   curl -fsSL https://claude.ai/install.sh | bash
   ```

### En Windows
1. Instala **Git para Windows**: https://git-scm.com/download/win (Claude Code lo necesita
   y además trae "Git Bash", donde funcionan los scripts de este proyecto).
2. Abre **PowerShell** e instala ffmpeg:
   ```powershell
   winget install Gyan.FFmpeg
   ```
3. Instala Claude Code:
   ```powershell
   irm https://claude.ai/install.ps1 | iex
   ```
4. Cierra y vuelve a abrir la terminal.

Comprueba que todo está bien:
```bash
claude --version
ffmpeg -version
```

## Paso 2 — Descargar este proyecto
```bash
git clone -b claude/dropshipping-viral-video-replication-c0vkhe https://github.com/marcserrano95-max/projecto-shopify.git
cd projecto-shopify
```

## Paso 3 — Iniciar sesión en Claude Code
```bash
claude
```
La primera vez se abre el navegador para iniciar sesión con tu cuenta de Claude
(la misma que usas en claude.ai; necesitas un plan Pro o Max).

## Paso 4 — Conectar Higgsfield (y Trendtrack)
Dentro de Claude Code escribe:
```
/mcp
```
- Si iniciaste sesión con la misma cuenta de claude.ai donde ya tienes conectados
  Higgsfield y Trendtrack, deberían aparecer en la lista. Si piden autenticación, sigue
  los pasos que aparecen.
- Si no aparecen, añádelos con la URL de servidor MCP que indica cada servicio en su web
  (sección "MCP" / "Claude"):
  ```bash
  claude mcp add --transport http higgsfield <URL_MCP_DE_HIGGSFIELD>
  ```
  y vuelve a abrir `claude` → `/mcp` para autenticarte.

Comprueba también que los agentes están cargados con:
```
/agents
```

## Paso 5 — Producir un vídeo
1. Crea una carpeta para el vídeo copiando la plantilla:
   ```bash
   cp -r proyectos/_plantilla proyectos/mi-producto-v1
   ```
2. Mete en `proyectos/mi-producto-v1/entrada/`:
   - el vídeo viral de referencia (recortado a la parte que te interesa, 5–30 s),
   - las fotos de tu producto y del packaging.
3. Rellena `proyectos/mi-producto-v1/brief.md`.
4. Abre `claude` en la carpeta del proyecto y pide, por ejemplo:
   > Produce el vídeo del proyecto proyectos/mi-producto-v1. Empieza con el analista-viral,
   > luego el guion y la voz, el avatar con el diseñador gráfico, los clips con Genjutsu
   > (cambiando el producto por el mío), la música, y al final móntalo con el editor-video.

   Claude irá llamando a cada agente. Antes de gastar créditos te enseñará el coste y te
   pedirá confirmación.

También puedes llamar a un agente concreto:
> Usa el agente productor-musical para cambiar la música por algo más enérgico.

## Estructura de cada proyecto
```
proyectos/mi-producto-v1/
├── brief.md          ← lo rellenas tú
├── analisis.md       ← analista-viral
├── guion.md          ← guionista-locutor
├── subtitulos.srt    ← guionista-locutor
├── estilo.md         ← disenador-grafico
├── entrada/          ← vídeo de referencia + fotos de producto/packaging
├── clips/            ← clips generados (01.mp4, 02.mp4…) y clips/ref/ imágenes
├── audio/            ← voz.mp3, musica.mp3, sfx/
└── salida/           ← final.mp4
```

## Scripts
- `scripts/render.sh proyectos/<nombre> [salida.mp4]` — monta el vídeo final
  (1080x1920, 30 fps, voz + música con la música bajando cuando habla, subtítulos quemados).
- `scripts/extraer-fotogramas.sh <video> <carpeta> [fps]` — saca fotogramas para analizar.

En Windows, ejecuta los scripts desde **Git Bash** (Claude Code ya los ejecuta ahí).

## Avisos
- Los vídeos y audios no se suben a GitHub (`.gitignore`), se quedan en tu ordenador.
- Replica la estructura e idea de los vídeos virales, no su material: no uses caras o
  voces de personas reales sin permiso, ni logos o música con copyright de otros.
