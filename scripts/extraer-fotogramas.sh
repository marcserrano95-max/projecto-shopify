#!/usr/bin/env bash
# Extrae fotogramas de un vídeo para poder analizarlo.
# Uso: scripts/extraer-fotogramas.sh <video> <carpeta_salida> [fotogramas_por_segundo]
set -euo pipefail

video="${1:?Uso: $0 <video> <carpeta_salida> [fps]}"
salida="${2:?Falta la carpeta de salida}"
fps="${3:-1}"

mkdir -p "$salida"
ffmpeg -hide_banner -loglevel error -y -i "$video" \
  -vf "fps=${fps},scale=540:-2" "$salida/frame_%03d.jpg"
echo "Fotogramas guardados en $salida ($(ls "$salida" | wc -l) imágenes)"
