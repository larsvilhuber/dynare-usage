#!/bin/bash

set -ev


# get full path
# we need to go one up
#

current="$(pwd)"
projectbase="$(pwd)"
cd "$current"

docker run -it --rm -v "$projectbase":/project -w /project/ rocker/verse:4.2.0 ./run.sh
