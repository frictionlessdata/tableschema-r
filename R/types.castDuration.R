#' @title cast duration
#' @param value value
#' @rdname types.castDuration
#' @export
#' @description cast duration
#' 

types.castDuration <- function (value) { #format parameter is not used   
  
  if (!lubridate::is.duration(value)) {
    
    if (!is.character(value)) stop("Value should be character or date class",call. = FALSE)
    
    #tryCatch({
      
    value=lubridate::as.duration(value)
    
    #if( not in milliseconds()) stop("Value should be in milliseconds",call. = FALSE)
    
    #},error= function(e) err<<-e)
    
    return(value)
    
  }
}

