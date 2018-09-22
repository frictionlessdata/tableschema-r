#' @title Cast string
#' @description Cast string that is, sequences of characters.
#' @param format available options are "default", "email", "uri", "binary" and "uuid", where
#' \describe{
#' \item{\code{default }}{Any valid string.}
#' \item{\code{email }}{A valid email address.}
#' \item{\code{uri }}{A valid URI.}
#' \item{\code{binary }}{A base64 encoded string representing binary data.}
#' \item{\code{uuid }}{A string that is a uuid.}
#' }
#' @param value string to cast
#' 
#' @rdname types.castString
#' 
#' @export
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#string}{Types and formats specifications}
#' 
#' @examples
#' 
#' # cast any string
#' types.castString(format = "default", value = "string")
#' 
#' # cast email
#' types.castString(format = "email", value = "name@gmail.com")
#' \dontshow{
#' # cast uri
#' types.castString(format = "uri", value = "http://google.com")
#' }
#' # cast binary
#' types.castString(format = "binary", value = "dGVzdA==")
#' 
#' # cast uuid
#' types.castString(format = "uuid", value = "95ecc380-afe9-11e4-9b6c-751b66dd541e")
#' 

types.castString <- function(format, value) {
  
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
  
  return(value)
  
}
