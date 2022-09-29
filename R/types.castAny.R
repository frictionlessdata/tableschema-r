#' @title Cast any value
#' @description Cast any value
#' @param format any format is accepted
#' @param value any value to cast
#' @rdname types.castAny
#' @export
#' @details Any type or format is accepted.
#' @seealso \href{https://specs.frictionlessdata.io//table-schema/#any}{Types and formats specifications}
#' 
#' @examples 
#' 
#' types.castAny(format = "default", value = 1)
#' 
#' types.castAny(format = "default", value = "1")
#' 
#' types.castAny(format = "default", value = "")
#' 
#' types.castAny(format = "default", value = TRUE)
#' 

types.castAny <- function(format, value) {
  return(value)
}