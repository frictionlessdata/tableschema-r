#' Check if a field is required
#' @param constraint constraint
#' @param value value
#' @return TRUE if a field is required
#' @rdname constraints.checkRequired
#' @export

constraints.checkRequired <- function (constraint, value) {
  
  if ( !( constraint && (is.null(value) | isTRUE(value == "undefined") | exists(deparse(substitute(value)))) ) ) return (TRUE)
  
  return (FALSE)
}

