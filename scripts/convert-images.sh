#!/usr/bin/env bash
# Converts photos in images-source/<category>/<name>.jpg into responsive
# WebP + JPEG sets at 400/800/1600px wide, written to images/<category>/.
#
# Usage:
#   1. Drop a source photo in images-source/<category>/, e.g.
#      images-source/rooms/mountain-view-room.jpg
#   2. Run: scripts/convert-images.sh
#   3. Reference it in HTML as images/<category>/<name>-{400,800,1600}.{webp,jpg}
#
# Requires: sips (macOS built-in) and cwebp (brew install webp).

set -euo pipefail

WIDTHS=(400 800 1600)
SRC_DIR="images-source"
OUT_DIR="images"

if ! command -v cwebp >/dev/null 2>&1; then
  echo "error: cwebp not found. Install with: brew install webp" >&2
  exit 1
fi
if ! command -v sips >/dev/null 2>&1; then
  echo "error: sips not found (expected on macOS)" >&2
  exit 1
fi

shopt -s nullglob
for category_dir in "$SRC_DIR"/*/; do
  category="$(basename "$category_dir")"
  mkdir -p "$OUT_DIR/$category"

  for src in "$category_dir"*.jpg "$category_dir"*.jpeg "$category_dir"*.JPG; do
    [ -e "$src" ] || continue
    name="$(basename "${src%.*}")"
    echo "==> $category/$name"

    src_width="$(sips -g pixelWidth "$src" | awk '/pixelWidth/{print $2}')"

    for w in "${WIDTHS[@]}"; do
      # Never upscale past the source's native width — cap the target instead.
      target=$w
      if [ "$src_width" -lt "$w" ]; then
        target="$src_width"
      fi

      tmp="$(mktemp -t "${name}-${w}").jpg"
      sips --resampleWidth "$target" "$src" --out "$tmp" >/dev/null

      jpg_out="$OUT_DIR/$category/${name}-${w}.jpg"
      cp "$tmp" "$jpg_out"

      webp_out="$OUT_DIR/$category/${name}-${w}.webp"
      cwebp -quiet -q 82 "$tmp" -o "$webp_out"

      rm -f "$tmp"
      if [ "$target" -lt "$w" ]; then
        echo "    ${w}px -> capped at native ${target}px (source is smaller) -> $jpg_out, $webp_out"
      else
        echo "    ${w}px -> $jpg_out, $webp_out"
      fi
    done
  done
done

echo "Done. Originals stay in $SRC_DIR/ — only $OUT_DIR/ is referenced by the site."
