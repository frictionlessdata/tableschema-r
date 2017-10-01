#' Check enum
#' @param constraint constraint
#' @param value value
#' @return TRUE value in constraint
#' @rdname constraints.checkEnum
#' @export

constraints.checkEnum <- function (constraint, value) {
  
  if( is.null(value) ) return (TRUE)
  
  if ( all(value %in% constraint) ) return (TRUE)
  
  return (FALSE)
  
}
