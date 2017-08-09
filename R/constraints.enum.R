#' Enum class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.


Enum <- R6Class("Enum", public = list(

checkEnum = function(constraint, value) {
        if (is.null(value)) {
            return (TRUE)
        }

        if (value %in% constraint) {
            return(TRUE)
        }

        return(FALSE)

     
        }

),
private = list(




    )


)
