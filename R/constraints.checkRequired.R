#' Check if a field is required
#' @param constraint constraint
#' @param value value
#' @return TRUE if a field is required
#' @rdname constraints.checkRequired
#' @export

constraints.checkRequired <- function (constraint, value) {
  
  !(constraint && (is.null(value) | exists(deparse(substitute(value))) ) ) 
  
}