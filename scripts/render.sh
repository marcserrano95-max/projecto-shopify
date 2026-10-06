#!/usr/bin/env bash
# Monta el vídeo final de un proyecto.
# Uso: scripts/render.sh proyectos/<nombre> [nombre_salida.mp4]
#
# Espera dentro del proyecto:
#   clips/*.mp4          clips en orden alfabético (01.mp4, 02.mp4, ...)  [obligatorio]
#   audio/voz.mp3        voz en off                                      [opcional]
#   audio/musica.mp3     música de fondo                                 [opcional]
#   subtitulos.srt       subtítulos que se queman en el vídeo            [opcional]
set -euo pipefail

proyecto="${1:?Uso: $0 proyectos/<nombre> [salida.mp4]}"
nombre_salida="${2:-final.mp4}"
proyecto="$(cd "$proyecto" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

shopt -s nullglob
clips=("$proyecto"/clips/*.mp4 "$proyecto"/clips/*.mov)
if [ ${#clips[@]} -eq 0 ]; then
  echo "No hay clips en $proyecto/clips/" >&2
  exit 1
fi
IFS=$'\n' clips=($(printf '%s\n' "${clips[@]}" | sort)); unset IFS

# 1) Normalizar cada clip a 1080x1920, 30 fps, sin audio.
: > "$tmp/lista.txt"
i=0
for c in "${clips[@]}"; do
  i=$((i + 1))
  ffmpeg -hide_banner -loglevel error -y -i "$c" \
    -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30,setsar=1" \
    -an -c:v libx264 -preset veryfast -crf 18 -pix_fmt yuv420p "$tmp/n$i.mp4"
  echo "file '$tmp/n$i.mp4'" >> "$tmp/lista.txt"
done

# 2) Concatenar.
ffmpeg -hide_banner -loglevel error -y -f concat -safe 0 -i "$tmp/lista.txt" -c copy "$tmp/video.mp4"
dur="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$tmp/video.mp4")"

# 3) Audio: voz + música (la música baja automáticamente cuando habla la voz).
voz="$proyecto/audio/voz.mp3"
musica="$proyecto/audio/musica.mp3"
entradas=(-i "$tmp/video.mp4")
filtro=""
mapa_audio=()
if [ -f "$voz" ] && [ -f "$musica" ]; then
  entradas+=(-i "$voz" -stream_loop -1 -i "$musica")
  filtro="[2:a]volume=0.35[m];[1:a]asplit=2[v][vk];[m][vk]sidechaincompress=threshold=0.03:ratio=8:attack=20:release=400[md];[v][md]amix=inputs=2:duration=longest:normalize=0,atrim=0:${dur},afade=t=out:st=$(awk "BEGIN{print $dur-0.8}"):d=0.8[a]"
  mapa_audio=(-map "[a]")
elif [ -f "$voz" ]; then
  entradas+=(-i "$voz")
  filtro="[1:a]apad,atrim=0:${dur}[a]"
  mapa_audio=(-map "[a]")
elif [ -f "$musica" ]; then
  entradas+=(-stream_loop -1 -i "$musica")
  filtro="[1:a]volume=0.8,atrim=0:${dur},afade=t=out:st=$(awk "BEGIN{print $dur-0.8}"):d=0.8[a]"
  mapa_audio=(-map "[a]")
fi

# 4) Subtítulos quemados (estilo TikTok: grandes, blancos con borde negro, en el centro-bajo).
vf="null"
if [ -f "$proyecto/subtitulos.srt" ]; then
  cp "$proyecto/subtitulos.srt" "$tmp/subs.srt"
  vf="subtitles=$tmp/subs.srt:force_style='FontName=Arial,FontSize=14,Bold=1,PrimaryColour=&H00FFFFFF,OutlineColour=&H00000000,BorderStyle=1,Outline=3,Shadow=0,Alignment=2,MarginV=70'"
fi

mkdir -p "$proyecto/salida"
salida="$proyecto/salida/$nombre_salida"
if [ -n "$filtro" ]; then
  ffmpeg -hide_banner -loglevel error -y "${entradas[@]}" \
    -filter_complex "$filtro" -map 0:v "${mapa_audio[@]}" -vf "$vf" \
    -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -c:a aac -b:a 192k \
    -movflags +faststart -t "$dur" "$salida"
else
  ffmpeg -hide_banner -loglevel error -y -i "$tmp/video.mp4" -vf "$vf" \
    -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -movflags +faststart "$salida"
fi
echo "Vídeo final: $salida (${dur}s)"
