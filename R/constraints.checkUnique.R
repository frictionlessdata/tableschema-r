#' is unique
#' @param x x
#' @return TRUE if unique 
#' @rdname constraints.checkUnique
#' @export

constraints.checkUnique <- function (x) {
  all(!anyDuplicated(x))
}