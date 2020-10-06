#!/bin/sh

die() {
  echo "$@"
  exit 1
}

NVENC() {
	pngfile="$1"
    nvcompress -bc1 "$pngfile" "$2"
	rm "$pngfile"
}

S2TC() {
	export S2TC_COLORDIST_MODE=SRGB_MIXED
	export S2TC_RANDOM_COLORS=64
	export S2TC_REFINE_COLORS=LOOP
	export S2TC_DITHER_MODE=FLOYDSTEINBERG
	pngfile="$1"
	tgafile="$(mktemp --suffix=.tga)"
	convert "$pngfile" "$tgafile"
	s2tc_compress -i "$tgafile" -o "$2" -t DXT1
	rm "$pngfile"
	rm "$tgafile"
}

[ $# -lt 3 ] && die "Usage: $(basename "$0") NVENC|S2TC <input.svg> <output.dds>"

method="$1"
shift
filename="$1"
shift
output="$1"
shift
pngfile="$(mktemp --suffix=.png)"

inkscape --export-type="png" --export-filename="$pngfile" "$filename"
case "$method" in
NVENC|S2TC)
	$method "$pngfile" "$output"
;;
*)
  die "Unsupported format: $method"
;;
esac
