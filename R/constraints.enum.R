#' @export 

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
