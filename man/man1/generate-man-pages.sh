#!/bin/bash

# Copyright 2021 Ankur Sinha
# Author: Ankur Sinha <sanjay DOT ankur AT gmail DOT com> 
# File : generate-man-pages.sh
#
# Generate man pages for all pyNeuroML command lines using help2man


if ! command -v help2man > /dev/null
then
    echo "Please install help2man: https://www.gnu.org/software/help2man/"
    exit 1
else
    if ! command -v pynml > /dev/null
    then
        echo "pynml not found in PATH"
        exit 2
    fi
    full_path=$(command -v pynml)
    bin_location=$(dirname $full_path)
    versioninfo=$(pynml -version | cut -f2 -d " ")
    fullversioninfo=$(pynml -version)

    # Create temporary include file for full version information
    echo "[environment]" > version.h2m
    echo ".PP" >> version.h2m
    echo "${fullversioninfo}" >> version.h2m

    cat common.h2m version.h2m >> common-temp.h2m

    for f in ${bin_location}/pynml*
    do
        echo "Generating man page for $f"
        current_file=$(basename $f)

        help2man --version-string="${versioninfo}" -N --section=1 --include="./common-temp.h2m" $f -o "${current_file}.1"
    done

    rm common-temp.h2m
fi

