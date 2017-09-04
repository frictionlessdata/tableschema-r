#' Check if minimum constraint is met
#' @param constraint constraint
#' @param value value
#' @return TRUE if value is less than the constraint
#' @rdname constraints.checkMinimum
#' @export

constraints.checkMinimum <- function(constraint, value){
  
  any( is.null(value) | value >= constraint )
  
}