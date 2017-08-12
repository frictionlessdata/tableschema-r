#' @title cast object
#' 
#' @rdname types.castObject
#' @export
#' @description cast object
#' 

types.castObject <- function (format, value) {
  
  if (!is.object(value)) {
    
    if (!is.character(value)) stop(1, call. = FALSE)
    
    tryCatch(
      
      value = jsonlite::fromJSON(value),
      
      error =  function(e) err<<-e
      )
    
  }
  
  #if ( ! plain object ) stop(2,call. = FALSE)
  
  return(value)
}
