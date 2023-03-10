#!/bin/sh -l

cd $1

current_dir="$1"
current_branch="$(git rev-parse --abbrev-ref HEAD)"
echo "Checking latestest push to $current_branch"


if [ -f DESCRIPTION ]; then
    echo "DESCRIPTION exist."
    
    
    R_script_test=($(git log -n 1 --raw --name-status --pretty=format: $current_branch | \
                    grep -E 'tests/testthat' | sed 's:.*/::' ))
                    
    echo -e "Test script changed: \n${R_script_test[*]}\n"
    
    R_script_func=($(git log -n 1 --raw --name-status --pretty=format: $current_branch | \
                    grep -E 'R/' | sed 's:.*/::' ))
                    
    echo -e "Function script changed: \n${R_script_func[*]}\n"
    
    for R_script in ${R_script_func[@]}
    do
      test_file=$(ls tests/testthat | grep -iE "$R_script")
      if [[ ! " ${R_script_test[*]} " =~ " ${test_file} " ]]; then
        R_script_test+="$test_file"
      fi
    done
    
    echo -e "Tests to run as: \n${R_script_test[*]}\n"
    
    for test_to_run in ${R_script_test[@]}
    do 
      
      test_call='test_file("'"$current_dir"'/tests/testthat/'"$test_to_run"'");'
      
      echo "====================================================================="
      echo -e "Running $test_call"
      
      Rscript -e 'if(! require("devtools")){install.packages("devtools")};library(devtools);sink(file="'"${current_dir}"'/test.log");load_all();'"$test_call"'sink()'  
      
      cat test.log
      echo "====================================================================="
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
    done
else 
    echo "DESCRIPTION file does not exist."
    exit 1
fi

