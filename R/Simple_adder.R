#' A simple adder code for toy package
#' @param item_1 first item to be added/combined.
#' @param item_2 second item to be added/combined.
#' 
#' @export Simple_adder
#' @return This function returns adding for two numeric and join for other scenarios
#' 

Simple_adder <- function (item_1, item_2){
  print("Customed Message")
  
  turn_numeric <- function (input){
    if (suppressWarnings(all(!is.na(as.numeric(as.character(input)))))) {
      output <- as.numeric(as.character(input))
    } else {
      output <- input
    }
    return(output)
  }
  
  if (class(turn_numeric(item_1)) != "numeric" || class(turn_numeric(item_2)) != "numeric"){
    return_item <- paste0(toString(item_1),toString(item_2))
  }else{
    return_item <- turn_numeric(item_1) + turn_numeric(item_2) 
  }
  
  return(return_item)
}
