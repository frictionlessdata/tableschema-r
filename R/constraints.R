#' @docType class
#' @importFrom R6 R6Class
#' @export

#' @include constraints.minimum.R
#' @include constraints.maximum.R
#' @include constraints.enum.R




Constraints <- R6Class("Constraints", public = list(constraints = list(
checkEnum = Enum$new()$checkEnum, checkMinimum = Minimum$new()$checkMinimum, checkMaximum = Maximum$new()$checkMaximum



)))
