#' @title cast boolean
#' 
#' @rdname types.castBoolean
#' @export
#' @description cast boolean
#' 
types.castBoolean <- function (value) { #format parameter is not used
  
  if  ( !is.logical(value) | !is.character(value) ) stop()
  
  value = trimws(tolower(value))
  
  if ( value %in% TRUE_VALUES ) {
    
    value = TRUE
  } else if ( value %in% FALSE_VALUES ) {
    
    value = FALSE
    
  } else  stop()
}

#' 
#' @export
 TRUE_VALUES = c('yes', 'y', 'true', 't', '1')
#' 
#' @export
 FALSE_VALUES = c('no', 'n', 'false', 'f', '0')
