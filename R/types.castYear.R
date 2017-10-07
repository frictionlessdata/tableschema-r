#' @title cast year
#' @description cast year
#' @param value value
#' @rdname types.castYear
#' @export
#' 
types.castYear <- function (format, value) { 
   
  if(!is_integer(value)){
    
    if (!is.character(value)) return(config::get("ERROR"))
    
    if (nchar(value) != 4) return(config::get("ERROR"))
    
    tryCatch({
      
      result = as.integer(value)
      
      if (is.nan(result) | as.character(result) != value)  return(config::get("ERROR"))
      
      value = result
      
    },
    
    warning = function(w) {
      
      message(config::get("WARNING"))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR"))
      
    },
    
    finally = {
      
    })
    
  }
  
  if (value < 0 | value > 9999) return(config::get("ERROR"))
  
  return(value)
  
}


