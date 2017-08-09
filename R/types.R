#' Types class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

#' @include types.number.R
#' @include types.string.R
#' @include types.integer.R


Types <- R6Class("Types", public = list(casts = list(

castNumber = Number$new()$castNumber,
castString = String$new()$castString,
castInteger = Integer$new()$castInteger



    )))
