#!/bin/env sh
NVENC(){
	name="$1"
	ddsfilename=`basename -s .png "$name"`".dds"
    nvcompress -bc1 "$name" "$ddsfilename"
	rm "$name"
}
S2TC(){
	export S2TC_COLORDIST_MODE=SRGB_MIXED
	export S2TC_RANDOM_COLORS=64
	export S2TC_REFINE_COLORS=LOOP
	export S2TC_DITHER_MODE=FLOYDSTEINBERG
	name="$1"
	tgafilename=`basename -s .png "$name"`".tga"
	ddsfilename=`basename -s .png "$name"`".dds"
	convert "$name" "$tgafilename"
	s2tc_compress -i "$tgafilename" -o "$ddsfilename" -t DXT1
	rm "$name"
	rm "$tgafilename"
}
if [ "$#" -lt 2 ]; then echo "Usage: $0 NVENC|S2TC <input>"; exit 1; fi
method="$1"
shift
filename="$1"
pngfilename=`basename -s .svg "$filename"`".png"
case $method in
NVENC)
inkscape --export-type="png" "$filename"
NVENC "$pngfilename"
;;
S2TC)
inkscape --export-type="png" "$filename"
S2TC "$pngfilename"
;;
*)
echo 'Only NVENC or S2TC is supported'
;;
esac
