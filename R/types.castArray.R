#' #' @title cast array
#' #' @description cast array
#' #' @param format format
#' #' @param value value
#' #' @rdname types.castArray
#' #' @export
#' #' 
#' types.castArray <- function (format, value) { #format parameter is not used
#'   
#'  if( !is.array(value) )
#'    if(!is.character(value) ) return(config::get("ERROR"))
#'   
#'   value = tryCatch({   
#'     
#'     value = jsonlite::fromJSON(value)
#'     
#'   },
#'   
#'   warning = function(w) {
#'     
#'     message(config::get("WARNING"))
#'     
#'   },
#'   
#'   error = function(e) {
#'     
#'     return(config::get("ERROR"))
#'     
#'   },
#'   
#'   finally = {
#'     
#'   })
#'   
#'   if (!is.array(value) ) return(config::get("ERROR"))
#'   
#'   return (value)
#'   
#' }
