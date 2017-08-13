#' @title cast object
#' @description cast object
#' @param value value
#' @rdname types.castObject
#' @export
#' 

types.castObject <- function (value) { #format parameter is not used
  
  if (!is.object(value)) {
    
    if (!is.character(value)) stop(1, call. = FALSE)
    
    tryCatch(
      
      value = jsonlite::fromJSON(value),
      
      error =  function(e) e
      
      )
    
  }
  
  #if ( ! plain object ) stop(2,call. = FALSE)
  
  return(value)
}
