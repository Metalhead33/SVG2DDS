#!/bin/sh

die() {
  echo "$@"
  exit 1
}

NVENC() {
	name="$1"
    nvcompress -bc1 "$name.png" "$name.dds"
	rm "$name"
}

S2TC() {
	export S2TC_COLORDIST_MODE=SRGB_MIXED
	export S2TC_RANDOM_COLORS=64
	export S2TC_REFINE_COLORS=LOOP
	export S2TC_DITHER_MODE=FLOYDSTEINBERG
	name="$1"
	convert "$name.png" "$name.tga"
	s2tc_compress -i "$name.tga" -o "$name.dds" -t DXT1
	rm "$name.png"
	rm "$name.tga"
}

[ $# -lt 2 ] && die "Usage: $(basename "$0") NVENC|S2TC <input.svg>"

method="$1"
shift
filename="$1"
shift
base="$(basename -s .svg "$filename")"

inkscape --export-type="png" "$filename"
case "$method" in
NVENC|S2TC)
	$method "$base"
;;
*)
  die "Unsupported format: $method"
;;
esac