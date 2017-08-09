#' String class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.
String <- R6Class("String", public = list(

castString = function(format, value, options = list()) {
    if (!(is.character(value) && length(value) > 0)) {
        return(config::get("ERROR"))
    }
    if (!is.null(format) &&  format == 'uri') {
        result = regexpr(private$URI_PATTERN, value)
        if (result[[1]] == -1) {
            return(config::get("ERROR"))

        }
    }
    else if (!is.null(format) && format == "email") {
        result = regexpr(private$EMAIL_PATTERN, value)
        if (result[[1]] == -1) {
            return(config::get("ERROR"))

        }
    }
    # TODO:implement validation
    else if (!is.null(format) && format == 'uuid') {

    }
    # TODO:implement validation
    else if (!is.null(format) && format == 'binary') {

    }
    return(value)

     
    }

),
private = list(




URI_PATTERN = '^http[s]?://',
EMAIL_PATTERN = '[^@]+@[^@]+\\.[^@]+'



    )


)

