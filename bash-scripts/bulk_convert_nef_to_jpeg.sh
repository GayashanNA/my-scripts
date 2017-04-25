#!/bin/bash
# Convert all the files with the extension NEF (nikon RAW files) to jpg format
# 
# How to use:
#       >./bulk_convert_nef_to_jpeg.sh <input dir: default current_dir> <output dir: default current_dir/output>
#

INPUT_DIRECTORY=${1:-.}
OUTPUT_DIRECTORY=${2:-output}
FILES=${INPUT_DIRECTORY}/*.NEF
mkdir ${INPUT_DIRECTORY}/${OUTPUT_DIRECTORY}

for f in ${FILES}
do
    echo "Processing ${f} file..."
    filename=$(basename $f)
    exiftool -b -JpgFromRaw ${f} > ${INPUT_DIRECTORY}/${OUTPUT_DIRECTORY}/${filename%.*}.jpg
done
