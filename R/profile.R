#' Profile class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include types.R
#' @include constraints.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

Profile <- R6Class(
"Profile",
public = list(
  initialize = function(profile) {
    # Set attributes
  
  },
  validate = function(descriptor = list()){
    return(list("valid" = TRUE))
  }
  
  
  
)



)
