#' @title cast object
#' @description cast object
#' @param value value
#' @rdname types.castObject
#' @export
#' 

types.castObject <- function (value) { #format parameter is not used
  
  if (!is.object(value)) {
    
    if (!is.character(value))  return(config::get("ERROR"))
    
    tryCatch(
      
      value = jsonlite::fromJSON(value),
      
      warning = function(w) {
        
        message(config::get("WARNING"))
        
      },
      
      error = function(e) {
        
        return(config::get("ERROR"))
        
      },
      
      finally = {
        
      })
    
  }
  
  #if ( ! plain object ) stop(2,call. = FALSE)
  
  return(value)
}
