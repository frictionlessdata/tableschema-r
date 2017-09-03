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
    
    if (!is.character(value)) return(config::get("ERROR"))
    
    if ("bareNumber" %in% names(options)) {
      
      bareNumber = options[["bareNumber"]]
      
      if(bareNumber==FALSE){
        
        value = gsub(gregexpr("((^\\D*)|(\\D*$))", value), "", value)
        
      }
    }
    
    tryCatch({
      
      result = as.integer(value)
      
      if (is.nan(result) || as.character(result) != value) return(config::get("ERROR"))
      
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
  
  return (value)
}
