#!/bin/bash
echo Counting words in $1
echo Result:
pdftotext $1 - | wc -w
