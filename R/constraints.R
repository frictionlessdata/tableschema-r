#' Constraints class
#' @description R6 class with constraints.
#' 
#' The constraints property on Table Schema Fields can be used by consumers to list constraints for 
#' validating field values. For example, validating the data in a Tabular Data Resource against 
#' its Table Schema; or as a means to validate data being collected or updated via a data entry interface.
#' 
#' All constraints \code{MUST} be tested against the logical representation of data, and the physical 
#' representation of constraint values \code{MAY} be primitive types as possible in JSON, 
#' or represented as strings that are castable with the type and format rules of the field.
#' 
#' 
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.
#' 
#' @include constraints.checkEnum.R
#' @include constraints.checkMaximum.R
#' @include constraints.checkMaxLength.R
#' @include constraints.checkMinimum.R
#' @include constraints.checkMinLength.R
#' @include constraints.checkPattern.R
#' @include constraints.checkRequired.R
#' @include constraints.checkUnique.R
#' 
#' @seealso \href{https://frictionlessdata.io/specs/table-schema/#constraints}{Constraints specifications},
#' \code{\link{constraints.checkEnum}}, 
#' \code{\link{constraints.checkMaximum}},
#' \code{\link{constraints.checkMaxLength}},
#' \code{\link{constraints.checkMinimum}},
#' \code{\link{constraints.checkMinLength}},
#' \code{\link{constraints.checkPattern}},
#' \code{\link{constraints.checkRequired}},
#' \code{\link{constraints.checkUnique}}

Constraints <- R6Class("Constraints", public = list(constraints = list(
  
  checkEnum       = constraints.checkEnum, 
  checkMaximum    = constraints.checkMaximum,   
  checkMaxLength  = constraints.checkMaxLength,   
  checkMinimum    = constraints.checkMinimum,   
  checkMinLength  = constraints.checkMinLength,   
  checkPattern    = constraints.checkPattern,   
  checkRequired   = constraints.checkRequired,   
  checkUnique     = constraints.checkUnique
  
)))
