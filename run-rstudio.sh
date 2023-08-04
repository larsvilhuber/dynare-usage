#!/bin/bash

set -ev


# get full path
# we need to go one up
#

current="$(pwd)"
projectbase="$(pwd)"
cd "$current"

docker run -e DISABLE_AUTH=true -v "$projectbase":/home/rstudio --rm -p 8787:8787 rocker/verse:4.2.0 
