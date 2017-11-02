#' Helpers class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.


Helpers <- R6Class("Helpers", public = list())

Helpers$expandFieldDescriptor <- function(descriptor) {
  if (!is.list(descriptor)) {
    stop("Field descriptor should be a hash instance.")
  }
  if (!("type" %in% names(descriptor))) {
    descriptor$type <- config::get("DEFAULT_FIELD_TYPE")
  }
  
  if (!("format" %in% names(descriptor))) {
    descriptor$format <- config::get("DEFAULT_FIELD_FORMAT")
  }
  return(descriptor)
}
helpers.checkUnique <- function(name,
                                value,
                                uniqueHeaders,
                                uniqueness){
  return(TRUE)
}

helpers.retrieveDescriptor <- function(descriptor) {
  return(future::future({
    # Inline

    if (jsonlite::validate(descriptor)) {
      descriptor = descriptor
      
      # Remote
    } else if (is.uri(descriptor)) {
      res = httr::GET(descriptor)
      descriptor = httr::content(res, as = 'text')
      
      # Loading error
      if (httr::status_code(res) >= 400) {
        browser()
        
        stop(TableSchemaError$new(
          stringr::str_interp("Can\'t load descriptor at '${descriptor}'"),
          errors
        ))
      }
      
      # Local
    } else {
      # Load/parse data
      descriptor = tryCatch({
        readr::read_file(system.file(descriptor, package = "tableschema.r"))

      },
      error = function(cond) {

        # Choose a return value in case of error
        return(TableSchemaError$new(
          stringr::str_interp("Can\'t load descriptor at '${descriptor}'")
        ))
      })

      
    }
    
    return(descriptor)
  }))
}

helpers.expandSchemaDescriptor <- function(descriptor) {
  return(descriptor)
}



#' Extract the field descriptors properties
#' @param descriptor The datapackage.json
#' @rdname get.field.descriptor.properties
#' @export


get.field.descriptor.properties = function(descriptor) {
  if (is.valid(descriptor) == TRUE) {
    descriptor.object = jsonlite::fromJSON(descriptor,
                                           simplifyVector = T,
                                           flatten = F)
    
    field_descriptor_classes = purrr::pmap_chr(descriptor.object$resources$schema$fields , class)
    
    field_descriptor_classes = gsub("data.frame",
                                    "array/list/object",
                                    field_descriptor_classes) # needs fix
    
    field_descriptor_classes_length = purrr::pmap_dbl(descriptor.object$resources$schema$fields , function(x)
      colSums(!is.na(as.data.frame(x))))
    
    field_descriptor_classes_missing = purrr::pmap_dbl(descriptor.object$resources$schema$fields , function(x)
      colSums(is.na(as.data.frame(x))))
    
    if (has_name_field_descriptor(descriptor.object)) {
      df = data.frame(
        root  = rlang::names2(field_descriptor_classes),
        class = field_descriptor_classes,
        items = field_descriptor_classes_length,
        missing = field_descriptor_classes_missing,
        
        fix.empty.names = FALSE,
        stringsAsFactors = FALSE
      )
      rownames(df) = NULL
      
    } else
      df = message(
        "The field descriptor MUST contain a name property. More spec details in https://specs.frictionlessdata.io/table-schema/#field-descriptors."
      )
    
  } else
    df = message("This is not a valid descriptor.")
  
  return(df)
}

#' check if name property is missing
#' @param descriptor descriptor
#' @rdname has_name_field_descriptor
#' @export
#'
has_name_field_descriptor = function(descriptor) {
  "name" %in% rlang::names2(descriptor) |
    all(!is.na(as.data.frame(descriptor$resources$schema$fields)[, "name"]))
}

#' is uri
#' @param uri uri input
#' @return TRUE if uri string
#' @rdname is.uri
#' @export
#'
is.uri <- function(uri) {
  if (!is.character(uri))
    message("The uri should be character")
  
  pattern = grepl("^http[s]?://", uri) |
    RCurl::url.exists(uri) #& !httr::http_error(uri)
  
  # if (!isTRUE(pattern)) {
  #
  #   pattern = httr::http_status(httr::GET(uri))
  #
  # }
  
  return(pattern)
}


#' is email
#' @param x email string
#' @rdname is.email
#' @return TRUE if email string
#' @export
#'

is.email <- function(x) {
  grepl("[^@]+@[^@]+\\.[^@]+", as.character(x), ignore.case = TRUE) # other email expr "\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>"
  
}

#' is binary
#' @param x input
#' @rdname is.binary
#' @return TRUE if binary
#' @export

is.binary = function (x)
  length(unique(stats::na.omit(x))) <= 2

#' is uuid
#' @param x input
#' @rdname is.uuid
#' @return TRUE if uuid
#' @export

is.uuid = function (x) {
  if (!is.character(x))
    stop("This is not a uuid object", call. = FALSE)
  
  nchar(x) == 36 & grepl("\\-", x)
}

#' Is integer
#' @description is integer
#' @param x value
#' @rdname is_integer
#' @export
#'

is_integer = function(x) {
  tryCatch({
    if (!is.character(x))
      x %% 1 == 0
    else
      FALSE
    
  },
  warning = function(w) {
    message(config::get("WARNING"))
    
  },
  
  error = function(e) {
    return(config::get("ERROR"))
    
  },
  
  finally = {
    
  })
  
}

#' Is empty
#' @description is empty
#' @param x x
#' @rdname is_empty
#' @export
#'
is_empty = function(x) {
  any(is.na(x) | is.null(x) | x == "")
  
}
