#' @title cast integer
#' @description cast integer
#' @param value value
#' @param format format
#' @param options options bareNumber
#' @rdname types.castInteger
#' @export
#' 

types.castInteger <- function (format, value, options={}) {
  
  if (!is_integer(value)) {
    
    if (!is.character(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    if ("bareNumber" %in% names(options)) {
      
      bareNumber = options[["bareNumber"]]
      
      if(bareNumber==FALSE){
        
        #value = gsub("(^\\D*)|(\\D*$)", value, "", value)
        value = stringr::str_replace_all(string=value, pattern="(^\\D*)|(\\D*$)", repl="") #gsub("\\s", "", value)
        
      }
    }
    
    value = tryCatch({
      
      result = as.integer(value)
      
      if (is.nan(result) || as.character(result) != value) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
      value = result
      
    },
    
    warning = function(w) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    error = function(e) {
      
      return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
      
    },
    
    finally = {
      
    })
    
  }
  
  return(value)
}
