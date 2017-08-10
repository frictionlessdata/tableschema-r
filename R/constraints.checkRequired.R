#' Check Minimum Length of Character/s according to a constraint
#' 
#' @return TRUE if the constraint of minimum character length is met 
#' @rdname constraints.checkRequired
#' @export

constraints.checkRequired <- function (constraint, value) {
  
  !(constraint && (is.null(value) | exists(deparse(substitute(value))) ) ) 
  
}