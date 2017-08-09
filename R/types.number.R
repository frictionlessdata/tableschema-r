#' Number class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

Number <- R6Class("Number", public = list(

    castNumber = function(format, value, options = list()) {
        percentage = FALSE
        currency = FALSE
        decimalChar = private$DEFAULT_DECIMAL_CHAR
        groupChar = private$DEFAULT_GROUP_CHAR
        if ("currency" %in% names(options)) currency = options[["currency"]]
        if ("decimalChar" %in% names(options)) decimalChar = options[["decimalChar"]]
        if ("groupChar" %in% names(options)) groupChar = options[["groupChar"]]


        if (!is.numeric(value)) {
            if (!is.character(value)) {
                return(config::get("ERROR"))
            }
            if (stringi::stri_length(value) < 1) {
                return(config::get("ERROR"))
            }
            value = gsub('\\s', '', value)
            if (stringi::stri_length(decimalChar) > 0) {
                value = gsub(stringr::str_interp("[${decimalChar}]"), '.', value)
            }
            if (stringi::stri_length(groupChar) > 0) {
                value = gsub(stringr::str_interp("[${groupChar}]"), '', value)
            }

            if (!is.null(currency) && currency != FALSE) {
                value = gsub(stringr::str_interp("[${private$CURRENCY_CHAR}]"), '', value)
            }
            result = gsub(stringr::str_interp("[${private$PERCENT_CHAR}]"), '', value)
            if (value != result) {
                percentage = true
                value = result
            }

            value = tryCatch({
                as.numeric(value)
            },
            warning = function(w) {
                return(config::get("ERROR"))

            },
            error = function(e) {
                return(config::get("ERROR"))
            },
                 finally = {
            })

        }
        if (is.nan(value)) {
            return(config::get("ERROR"))
        }
        if (percentage) {
            value = value / 100
        }
        return(value)
    }

),
private = list(

DEFAULT_DECIMAL_CHAR = '.',
DEFAULT_GROUP_CHAR = '',
PERCENT_CHAR = '%',
CURRENCY_CHAR = '$'



    )


)

