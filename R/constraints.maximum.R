#' @export 

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
