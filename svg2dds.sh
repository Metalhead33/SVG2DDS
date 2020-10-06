#/bin/bash
function NVENC {
	name = "$1"
    nvcompress -bc1 "$name" "${name/.png/.dds}"
	rm "$name"
}
function S2TC {
	export S2TC_COLORDIST_MODE=SRGB_MIXED
	export S2TC_RANDOM_COLORS=64
	export S2TC_REFINE_COLORS=LOOP
	export S2TC_DITHER_MODE=FLOYDSTEINBERG
	name = "$1"
	convert "$name" "${name/.png/.tga}"
	s2tc_compress -i "${name/.png/.tga}" -o "${name/.png/.dds}" -t DXT1
	rm "$name"
	rm "${name/.png/.tga}"
}
if [ -z "$1" ]
	echo -e 'You need to define compression method: NVENC or S2TC.\n(Use NVENC only if you have an nVidia card!)'
	exit 1
fi
if [ "$1" -ne "NVENC" ] && [ "$1" -ne "S2TC" ]
	echo -e 'You need to define compression method: NVENC or S2TC.\n(Use NVENC only if you have an nVidia card!)'
	exit 1
fi
if [ -z "$2" ]
	echo -e 'Please define an image as an input to convert.'
	exit 1
fi
inkscape --export-type="png" "$2"
"$1" "${name/.svg/.png}"
