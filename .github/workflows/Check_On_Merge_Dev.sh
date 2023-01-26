#!/bin/sh -l

cd $1

current_dir="$1"
# Check if DESCRIPTION file exist

if [ -f DESCRIPTION ]; then
    echo "DESCRIPTION exist."
    
    Rscript -e 'if(! require("devtools")){install.packages("devtools")};'
    Rscript -e 'library(devtools);sink(file="'${current_dir}'/test.log");test();sink()'  
    
    cat test.log
    
    ERROR_num=$(tail -n 1 test.log | cut -d' ' -f 1)
    
    if [ "$ERROR_num" != "0" ]; then
      echo "Number of ERROR in check is $ERROR_num"
      exit 2
    else
      echo "Passed Check!"
    fi
    
else 
    echo "DESCRIPTION file does not exist."
    exit 1
fi

