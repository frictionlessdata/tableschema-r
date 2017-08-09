#' @export 

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
