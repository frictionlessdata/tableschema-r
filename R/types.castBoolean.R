#' @title cast boolean
#' @description cast boolean
#' @param value value
#' @rdname types.castBoolean
#' @export
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

#' true values
#' @export
 TRUE_VALUES = c('yes', 'y', 'true', 't', '1')
#' false values
#' @export
 FALSE_VALUES = c('no', 'n', 'false', 'f', '0')
