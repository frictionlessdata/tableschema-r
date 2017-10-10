#' Check if minimum constraint is met
#' @param constraint constraint
#' @param value value
#' @return TRUE if value is less than the constraint
#' @rdname constraints.checkMinimum
#' @export

constraints.checkMinimum <- function(constraint, value){
  
  if( is.null(value) ) return (TRUE)
  
  if ( all(value >= constraint) ) return (TRUE)
  
  return (FALSE)
  
}