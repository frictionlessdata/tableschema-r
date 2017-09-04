#' Check if maximum constraint is met
#' @param constraint constraint
#' @param value value
#' @return TRUE if value is less than the constraint
#' @rdname constraints.checkMaximum
#' @export

constraints.checkMaximum <- function(constraint, value){
  
  any( is.null(value) | value <= constraint )
  
}