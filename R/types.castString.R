#' @title cast string
#' @description cast string
#' @param value value
#' @param format format
#' @rdname types.castString
#' @export
#' 

types.castString <- function (format, value) {
  
  if (!is.character(value) && length(value) > 0) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
  if (!is.null(format) && format == "uri") {
    
    if (!is.uri(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
  } else if (!is.null(format) && format == "email") {
    
    if (!is.email(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
  } else if (!is.null(format) && format == "uuid") {
    
    if (!is.uuid(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
    
  } else if (!is.null(format) && format == "binary") {
    
    if (!is.binary(value)) return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
  }
  
  return (value)
  
}
