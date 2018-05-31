#' @title cast year
#' @description cast year
#' @param value value
#' @param format format
#' @rdname types.castYear
#' @export
#' 
types.castYear <- function (format, value) { 
   
  if(!is_integer(value)){
    
    if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    if (nchar(value) != 4) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    tryCatch({
      
      result = as.integer(value)
      
      if (is.nan(result) | as.character(result) != value)  return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      value = result
      
    },
    
    warning = function(w) {
      
      message(config::get("WARNING", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    finally = {
      
    })
    
  }
  
  if (value < 0 | value > 9999) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
  return(value)
  
}


