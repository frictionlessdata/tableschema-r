#' @title cast year
#' 
#' @rdname types.castYear
#' @export
#' @description cast year
#' 
types.castYear <- function (value) { #format parameter is not used   
   
  if(!is_integer(value)){
    if (!is.character(value)) stop("The input value should be integer or character", call. = FALSE)
    if (nchar(value) != 4) stop("The year value should be specified by 4 digits.", call. = FALSE)
    
    tryCatch({
      result = as.integer(value)
      if (is.nan(result) | as.character(result) != value)  stop(3, call. = FALSE)
      value = result
    },
    error = function(e)  err <<- e,
    warning=function(w) warn <<- w
      )
    
  }
  
  if (value < 0 | value > 9999) stop("The input year should not be negative or over 9999", call. = FALSE)
  
  return(value)
  
}



#' Is integer
#' @description is integer
#' @rdname types.castYear
#' @export
#' 
is_integer=function(x, tol = .Machine$double.eps^0.5) {
  
  withCallingHandlers( tryCatch({
    
    if(is.character(x)) {
      
      war=warning("Tried to convert character to integer",call. = FALSE)
      
      if(!grepl("\\.",x) ){
        
        as.integer(x)%%1==0
        
      } else FALSE
      
    } else x%%1==0
    
  }, 
  error=function(e) FALSE
  ),
  
  warning=function(w) warn<<-w )
}

