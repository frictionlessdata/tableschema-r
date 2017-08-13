#' @title cast array
#' @description cast array
#' @param value value
#' @rdname types.castArray
#' @export
#' 
types.castArray <- function (value) { #format parameter is not used
  
 if( !is.array(value) | !is.list(value) | !is.character(value) ) stop("value is not a valid array or list object")
  
  tryCatch({
   #value=jsonlite::fromJSON(value)
   if (!is.array(value) | !is.list(value) ) stop()
  },
  error= function(e) message("value is not a valid array or list object")  )
  
}
