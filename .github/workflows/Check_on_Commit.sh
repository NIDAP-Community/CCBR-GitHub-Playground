#!/bin/sh -l

cd $1

current_dir="$1"
# Check if DESCRIPTION file exist

if [ -f DESCRIPTION ]; then
    echo "DESCRIPTION exist."
    
    Rscript -e 'if(! require("devtools")){install.packages("devtools")};'
    Rscript -e 'library(devtools);sink(file="'${current_dir}'/test.log");load_all();test();sink()'  
    
    cat test.log
    
    PASS_num=$(tail -n 1 test.log | cut -d'|' -f 4 | cut -d' ' -f 3)
    
    if [ "$PASS_num" != "1" ]; then
      echo "Number of PASS in test is $PASS_num"
      exit 2
    else
      echo "Passed Check!"
    fi
    
else 
    echo "DESCRIPTION file does not exist."
    exit 1
fi

