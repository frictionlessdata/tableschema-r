#' @title cast year
#' @description cast year
#' @param value value
#' @rdname types.castYear
#' @export
#' 
types.castYear <- function (value) { #format parameter is not used   
   
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



#' Is integer
#' @description is integer
#' @param x value
#' @param tol tolerance
#' @rdname is_integer
#' @export
#' 
is_integer=function(x, tol = .Machine$double.eps^0.5) {
  
  tryCatch({
    
    if(is.character(x)) {
      
      message(config::get("WARNING"))
      
      #war=warning("Tried to convert character to integer",call. = FALSE)
      
      if(!grepl("\\.",x) ){
        
        as.integer(x)%%1==0
        
      } else FALSE
      
    } else x%%1==0
    
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

