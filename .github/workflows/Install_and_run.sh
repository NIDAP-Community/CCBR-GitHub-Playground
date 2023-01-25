#!/bin/sh -l

cd $1

current_dir="$1"
# Check if DESCRIPTION file exist

if [ -f DESCRIPTION ]; then
    echo "DESCRIPTION exist."
    
    Rscript -e 'if(! require("devtools")){install.packages("devtools")};'
    Rscript -e 'library(devtools);sink(file="'${current_dir}'/test.log");load_all();test();sink()'  
    
    echo $(ls)
    
    FAIL_num=$(tail -n 1 test.log | cut -d'|' -f 1 | cut -d' ' -f 3)
    
    if [ $FAIL_num -ne 0 ]; then
      echo "Number of FAIL in chekc is $FAIL_num"
      exit 2
    else
      echo "Passed Check!"
    fi
    
else 
    echo "DESCRIPTION file does not exist."
    exit 1
fi

