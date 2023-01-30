test_that("Check simple adder", {
  
  example_inputs <- read.csv(test_path("fixtures", "adder_toy_input.csv"), header = FALSE)
  
  example_outputs <- read.csv(test_path("fixtures", "adder_toy_output.csv"), header = FALSE)
  
  output_list <- c()
  
  for (row in 1:dim(example_inputs)[1]){
    
    adder_result <- Simple_adder(example_inputs[row,"V1"], example_inputs[row,"V2"])
    output_list <- append(output_list, adder_result)
  }
 
  TRUE_count <- as.numeric(table(output_list==example_outputs)["TRUE"])
  
  print(output_list)
  
  # test note1
  warning("This is to supress the test encourage line")
  expect_equal(TRUE_count,8)
})