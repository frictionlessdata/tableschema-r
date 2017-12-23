#' @title cast list
#' @description cast list
#' @param value value
#' @rdname types.castList
#' @export
#' 
types.castList <- function (value) { #format parameter is not used
  
  if( !is.list(value) )
    if(!is.character(value) ) return(config::get("ERROR"))
  
  value = tryCatch({   
    
    value = jsonlite::fromJSON(value)
    
  },
  
  warning = function(w) {
    
    return(config::get("ERROR"))
    
  },
  
  error = function(e) {
    
    return(config::get("ERROR"))
    
  },
  
  finally = {
    
  })
  
  if (!is.list(value) ) return(config::get("ERROR"))
  
  return (value)
  
}
