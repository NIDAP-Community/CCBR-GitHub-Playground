#!/bin/sh -l

cd $1

current_dir="$1"
current_branch=$(git rev-parse --abbrev-ref HEAD)
# Check if DESCRIPTION file exist

#https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-an-array-in-bash

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

if [ -f DESCRIPTION ]; then
    echo "DESCRIPTION exist."
    
    
    R_script_test=($(git log -n 1 --raw --name-status --pretty=format: $current_branch | \
                    grep -E 'tests/testthat' | sed 's:.*/::' ))
    
    R_script_func=($(git log -n 1 --raw --name-status --pretty=format: $current_branch | \
                    grep -E 'R/' | sed 's:.*/::' ))
    
    for R_script in ${R_script_func[@]}
    do
      test_file=$(ls tests/testthat | grep -E "$R_script")
      echo $test_file
      if [[ ! " ${R_script_test[*]} " =~ " ${test_file} " ]]; then
        R_script_test+="$test_file"
      fi
    done
    
    
    Rscript -e 'if(! require("devtools")){install.packages("devtools")};'
    Rscript -e 'library(devtools);sink(file="'${current_dir}'/test.log");load_all();test();sink()'  
    
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

