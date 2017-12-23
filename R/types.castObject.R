#' @title cast object
#' @description cast object
#' @param format format
#' @param value value
#' @rdname types.castObject
#' @export
#' 

types.castObject <- function(format, value) { #format parameter is not used
  
  if (!is.object(value)) {
    
    if (!is.character(value))  return(config::get("ERROR"))
    
    value = tryCatch(
      {
        value = jsonlite::fromJSON(value)
        if (!is.list(value)){
          return(config::get("ERROR"))
        }
      },
      warning = function(w) {
        
        return(config::get("WARNING"))
        
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
