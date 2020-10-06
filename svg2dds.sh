#/bin/bash
function NVENC {
	local name="$1"
    nvcompress -bc1 "$name" "${name/.png/.dds}"
	rm "$name"
}
function S2TC {
	export S2TC_COLORDIST_MODE=SRGB_MIXED
	export S2TC_RANDOM_COLORS=64
	export S2TC_REFINE_COLORS=LOOP
	export S2TC_DITHER_MODE=FLOYDSTEINBERG
	local name="$1"
	convert "$name" "${name/.png/.tga}"
	s2tc_compress -i "${name/.png/.tga}" -o "${name/.png/.dds}" -t DXT1
	rm "$name"
	rm "${name/.png/.tga}"
}
if [[ -z "$1" ]]; then
	echo -e 'You need to define compression method: NVENC or S2TC.\n(Use NVENC only if you have an nVidia card!)'
	exit 1
fi
if [[ "$1" -ne "NVENC" ]] && [ "$1" -ne "S2TC" ]; then
	echo -e 'You need to define compression method: NVENC or S2TC.\n(Use NVENC only if you have an nVidia card!)'
	exit 1
fi
if [[ -z "$2" ]]; then
	echo -e 'Please define an image as an input to convert.'
	exit 1
fi
filename="$2"
pngfilename="${filename/.svg/.png}"
inkscape --export-type="png" "$filename"
if [[ "$1" == "NVENC" ]]; then
	NVENC "$pngfilename"
	exit 0
elif [[ "$1" == "S2TC" ]]; then
	S2TC "$pngfilename"
	exit 0
else
	rm "$pngfilename"
	exit 0
fi
