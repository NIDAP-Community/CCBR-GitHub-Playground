#!/bin/sh -l

cd $1

current_dir="$1"
# Check if DESCRIPTION file exist

if [ -f DESCRIPTION ]; then
    echo "DESCRIPTION exist."
    
    Rscript -e 'if(! require("devtools")){install.packages("devtools")};'
    Rscript -e 'library(devtools);sink(file="'${current_dir}'/test.log");test();sink()'  
    
    cat test.log
    
    echo "====================================================================="
    
    message_check=$(tail -n 1 test.log | cut -d'|' -f 4 | cut -d' ' -f 2)
    echo "Message Check: $message_check"
    
    if [ "$message_check" = "PASS" ]; then
      FAIL_num=$(tail -n 1 test.log | cut -d'|' -f 1 | cut -d' ' -f 3)
      if [ "$FAIL_num" != "0" ]; then
        echo "Number of FAIL in test is $FAIL_num"
        exit 2
      else
        echo "Passed Check!"
      fi
      
    else
      FAIL_num=$(tail -n3 test.log | head -n1 | cut -d'|' -f 1 | cut -d' ' -f 3)
      
      if [ "$FAIL_num" != "0" ]; then
        echo "Number of FAIL in test is $FAIL_num"
        exit 2
      else
        echo "Passed Check!"
      fi
    fi
    
else 
    echo "DESCRIPTION file does not exist."
    exit 1
fi

