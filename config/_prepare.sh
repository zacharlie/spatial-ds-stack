#!/usr/bin/bash

THISDIR="$( cd "" >/dev/null 2>&1 && pwd )"

cd "${THISDIR}"

for filename in "./*.example"; do
    echo cloning $filename
    cp "$filename" "${filename%.*}"
done
