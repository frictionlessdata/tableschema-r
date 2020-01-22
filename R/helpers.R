#' Retrieve Descriptor
#' @description Helper function to retrieve descriptor
#' @param descriptor descriptor
#' @rdname helpers.retrieveDescriptor
#' @export

helpers.retrieveDescriptor <- function(descriptor) {
  return(future::future({
    # Inline
    
    
    if (jsonlite::validate(descriptor)) {
      descriptor <- descriptor
      
      # Remote
    } else if (is.uri(descriptor)) {
      res <- httr::GET(descriptor)
      descriptor <- httr::content(res, as = 'text')
      
      # Loading error
      if (httr::status_code(res) >= 400) {
        
        stop(
          stringr::str_interp("Can\'t load descriptor at '${descriptor}'")#,
          #errors
        )
      }
      
      # Local
    } else {
      # Load/parse data
      descriptor <- tryCatch({
        data <- readLines(descriptor,encoding = "UTF-8", warn = FALSE)
        valid <- jsonlite::validate(data)
        
        if (valid == FALSE) {
          stop(
            stringr::str_interp("Can\'t load descriptor at '${descriptor}'")          )
        }
        else{
          return(data)
        }
        
      },
      error = function(cond) {
        # Choose a return value in case of error
        stop(
          stringr::str_interp("Can\'t load descriptor at '${descriptor}': ${cond$message}")
        )
      },
      warning = function(cond) {
        # Choose a return value in case of error
        stop(
          stringr::str_interp("Can\'t load descriptor at '${descriptor}': ${cond$message}")
        )
      })
    }
    return(descriptor)
  }))
}


#' Expand Schema Descriptor
#' @description Helper function to expand schema descriptor
#' @param descriptor descriptor
#' @rdname helpers.expandSchemaDescriptor
#' @export
#' 

helpers.expandSchemaDescriptor <- function(descriptor) {
  
  for (index in 1:length(descriptor$fields)) {
    field <- descriptor$fields[[index]]
    descriptor$fields[[index]] <- helpers.expandFieldDescriptor(field)
  }
  if (is.null(descriptor$missingValues) || length(descriptor$missingValues) == 0)  descriptor$missingValues <- as.list(config::get("DEFAULT_MISSING_VALUES", file = system.file("config/config.yml", package = "tableschema.r")))
  
  return(descriptor)
}


#' Expand Field Descriptor
#' @description Helper function to expand field descriptor
#' @param descriptor descriptor
#' @rdname helpers.expandFieldDescriptor
#' @export
#' 

helpers.expandFieldDescriptor <- function(descriptor) {

  if (is.list(descriptor)) {
    if (any(is.null(descriptor$type) | !("type" %in% names(descriptor)))) descriptor$type <- config::get("DEFAULT_FIELD_TYPE", file = system.file("config/config.yml", package = "tableschema.r"))
    if (any(is.null(descriptor$format) | !("format" %in% names(descriptor)))) descriptor$format <- config::get("DEFAULT_FIELD_FORMAT", file = system.file("config/config.yml", package = "tableschema.r"))
  }
  return(descriptor)
}


#' Is uri
#' @param uri uri input
#' @return TRUE if uri string
#' @rdname is.uri
#' @export
#'

is.uri <- function(uri) {
  if (!is.character(uri))
    stop("The uri should be character")
  
  pattern <- grepl("^http[s]?://", uri) |
    RCurl::url.exists(uri) #& !httr::http_error(uri)
  return(pattern)
}


#' Is email
#' @param x email string
#' @rdname is.email
#' @return TRUE if x is email
#' @export
#'

is.email <- function(x) {
  grepl("[^@]+@[^@]+\\.[^@]+", as.character(x), ignore.case = TRUE) # other email expr "\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>"
}

#' Is binary
#' @param x input value to check
#' @rdname is.binary
#' @return TRUE if binary
#' @export

is.binary <- function(x){
  if (any(endsWith(x,suffix = "==") ||endsWith(x,suffix = "=") ||
          (grepl("^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$",x) & isTRUE(x!="") )||
          is.raw(jsonlite::base64_enc(x)))) TRUE else FALSE
}

# length(unique(stats::na.omit(x))) <= 2

#' Is uuid
#' @param x character
#' @rdname is.uuid
#' @return TRUE if uuid
#' @export

is.uuid <- function(x) {
  if (!is.character(x))
    stop("This is not a uuid object", call. = FALSE)
  
  nchar(x) == 36 & grepl("\\-", x)
}

#' Is integer
#' @description Is integer
#' @param x number
#' @rdname is_integer
#' @export
#'

is_integer <- function(x) {
  if (is_object(x)) return(FALSE) else
  tryCatch({
    if (!is.character(x))
      x %% 1 == 0
    else
      FALSE
    
  },
  warning = function(w) {
    message(config::get("WARNING", file = system.file("config/config.yml", package = "tableschema.r")))
    
  },
  
  error = function(e) {
    return(config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
    
  },
  
  finally = {
    
  })
  
}

#' Is empty
#' @description Is empty list
#' @param x list object
#' @rdname is_empty
#' @export
#'
is_empty <- function(x) {
  
  if (is.list(x) & length(x) == 0) TRUE
  
  else any(is.na(x) | is.null(x) | x == "")
  
}

#' Is object
#' @description Is object
#' @param x list, array, json string
#' @rdname is_object
#' @export
#'
is_object <- function(x) {
  if (isTRUE(class(x) %in% c("list","array","json") | 
             isTRUE(is.object(x))) | (isTRUE(is.character(x) && jsonlite::validate(x)))) TRUE
  else FALSE
}
#' Convert json to list
#' @param lst list
#' @rdname helpers.from.json.to.list
#' @export
#'
helpers.from.json.to.list <- function(lst){
  return(jsonlite::fromJSON(lst, simplifyVector = FALSE))
}
#' Convert list to json
#' @param json json string
#' @rdname helpers.from.list.to.json
#' @export
#'
helpers.from.list.to.json <- function(json){
  return(jsonlite::toJSON(json, auto_unbox = TRUE))
}


#' Save json file
#' @description save json
#' @param x list object
#' @param file file
#' @rdname write_json
#' @export
#'

write_json <- function(x, file){
  x <- jsonlite::prettify(helpers.from.list.to.json(x))
  x <- writeLines(x, file)
}
