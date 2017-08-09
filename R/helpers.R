#' Helpers class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

library(R6)
library(hash)
library(config)

Helpers <- R6Class("Helpers", public = list())

Helpers$expandFieldDescriptor <- function(descriptor) {
    if (!is.hash(descriptor)) {
        stop("Field descriptor should be a hash instance.")
    }
    if (!has.key("type", descriptor)) {
        descriptor$type <- config::get("DEFAULT_FIELD_TYPE")
    }
    if (!has.key("format", descriptor)) {
        descriptor$format <- config::get("DEFAULT_FIELD_FORMAT")
    }
    return(descriptor)
}




