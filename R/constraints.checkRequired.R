#' Check Minimum Length of Character/s according to a constraint
#' @param constraint constraint
#' @param value value
#' @return TRUE if the constraint of minimum character length is met 
#' @rdname constraints.checkRequired
#' @export

constraints.checkRequired <- function (constraint, value) {
  
  !(constraint && (is.null(value) | exists(deparse(substitute(value))) ) ) 
  
}