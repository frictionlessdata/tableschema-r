#' @title cast boolean
#' @description cast boolean
#' @param format format
#' @param value value
#' @param options options specify trueValues or/and falseValues
#' @rdname types.castBoolean
#' @export
#' 

types.castBoolean <- function (format, value, options={}) { #format parameter is not used
  
  if ("trueValues" %in% names(options)) TRUE_VALUES = options[["trueValues"]]
  
  if ("falseValues" %in% names(options)) FALSE_VALUES = options[["falseValues"]]
  
  
  if  ( !is.logical(value) ) {
    
    if ( !is.character(value) ) return(config::get("ERROR"))
    
    value = trimws(value)
    
    if ( value %in% TRUE_VALUES ) {
      
      value = TRUE
      
    } else if ( value %in% FALSE_VALUES ) {
      
      value = FALSE
      
    } else  return(config::get("ERROR"))
    
  }
  
  return(value)
  
}



#' default true values
#' @export
 TRUE_VALUES = c("true", "True", "TRUE", "1")
 
#' default false values
#' @export
 FALSE_VALUES = c("false", "False", "FALSE", "0")
