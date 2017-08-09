#' @docType class
#' @importFrom R6 R6Class
#' @export

#' @include types.number.R
#' @include types.string.R
#' @include types.integer.R


Types <- R6Class("Types", public = list(casts = list(

castNumber = Number$new()$castNumber,
castString = String$new()$castString,
castInteger = Integer$new()$castInteger



    )))
