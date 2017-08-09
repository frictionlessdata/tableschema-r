#' Integer class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

Integer <- R6Class("Integer", public = list(

castInteger = function(format, value, options = list()) {

   
    if (is.numeric(value) && value %% 1 != 0) {
        if (!(is.character(value) && length(value) > 0)) {
            return(config::get("ERROR"))
        }


        result = tryCatch({
            as.integer(value)
        },
            warning = function(w) {
                return(config::get("ERROR"))

            },
            error = function(e) {
                return(config::get("ERROR"))
            },
                 finally = {
         })

        if (is.nan(value) || as.character(result) != value) {
            return(config::get("ERROR"))

        }

        value = result
    }

    return(value)




}

),
private = list(




URI_PATTERN = '^http[s]?://',
EMAIL_PATTERN = '[^@]+@[^@]+\\.[^@]+'



    )


)
