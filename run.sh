#!/bin/bash


for arg in $(ls [0-9]*.R)
do
R CMD BATCH ${arg} 
done

tail *.Rout

# now do the Rmd file

Rscript -e "rmarkdown::render('README.Rmd')"
