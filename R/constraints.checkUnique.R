#' Check if a field is unique
#' @param x x
#' @return TRUE if field is unique 
#' @rdname constraints.checkUnique
#' @export

constraints.checkUnique <- function (x) {
  all(!anyDuplicated(x))
}