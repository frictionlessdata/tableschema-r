#' Constraints class
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
