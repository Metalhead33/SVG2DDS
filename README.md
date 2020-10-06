
# svg2dds

Bash script that converts an SVG file to a DDS file. Useful for creating religion icons for Crusader Kings 3.
Requires Inkscape first and foremost, and either [Nvidia Texture Tools](https://github.com/castano/nvidia-texture-tools) or [S2TC](https://github.com/divVerent/s2tc). Supported only on Linux

**Usage:**

    ./svg2dds.sh <S2TC or NVENC> <name of the file you want to convert.svg> <output destination.dds>
