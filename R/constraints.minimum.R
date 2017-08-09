#' Minimum class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.


Minimum <- R6Class("Minimum", public = list(

checkMinimum = function(constraint, value) {
    if (is.null(value)) {
        return(TRUE)
    }

    if (value >= constraint) {
        return(TRUE)
    }

    return(FALSE)


}

),
private = list(




    )


)
