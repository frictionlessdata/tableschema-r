#' @title cast geojson
#' @description cast geojson
#' @param format format
#' @param value value
#' @rdname types.castGeojson
#' @export
#' 

types.castGeojson <- function (format, value) {
  
  if (!is.object(value)) {
    
    if (!is.character(value)) stop("This is not a valid object." ,call. = FALSE)
    
    tryCatch( {
      
      value = jsonlite::fromJSON(value)
      
    },error=function(e) e
    
    )
  }
  
  if (format == "default") {
    
    tryCatch( {
      
      valid = is.valid(value, "profile") # profile a geojson schema
      
      if (!valid) stop("This is not a valid geojson object", call. = FALSE)
      
    },error = function(e) e
    
    )
    
  } else if (format == "topojson") {
    
    if ( !is.null(value) | !is.list(value) ) stop("This is not a valid geojson object",call. = FALSE)
    
  }
  
  return (value)
}
