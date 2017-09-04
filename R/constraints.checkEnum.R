#' Check enum
#' @param constraint constraint
#' @param value value
#' @return TRUE value in constraint
#' @rdname constraints.checkEnum
#' @export

constraints.checkEnum <- function (constraint, value) {
  
  is.null(value) | value %in% constraint
  
}