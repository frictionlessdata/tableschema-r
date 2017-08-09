#' Maximum class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

Maximum <- R6Class("Maximum", public = list(

checkMaximum = function(constraint, value) {
    if (is.null(value)) {
        return(TRUE)
    }

    if (value <= constraint) {
        return(TRUE)
    }

    return(FALSE)


}

),
private = list(




    )


)
