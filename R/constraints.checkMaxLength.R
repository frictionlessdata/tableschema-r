#' Check Maximum Length of Character/s according to a constraint
#' @param constraint constraint
#' @param value value
#' @return TRUE if the constraint of maximum character length is met 
#' @rdname constraints.checkMaxLength
#' @export

constraints.checkMaxLength <- function(constraint, value){
  
  if( is.null(value) ) return (TRUE)
  
  if ( all(nchar(value)  <= constraint) ) return (TRUE)
  
  return (FALSE)
}