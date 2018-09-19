#' Field class
#'
#' @description Class represents field in the schema.
#' 
#' Data values can be cast to native R types. Casting a value will check 
#' the value is of the expected type, is in the correct format, 
#' and complies with any constraints imposed by a schema.
#' 
#' @usage # Field$new(descriptor, missingValues = list(""))
#' @param descriptor Schema field descriptor
#' @param missingValues A list with vector strings representing missing values
#' 
#' 
#' @section Methods:
#' \describe{
#' 
#' \item{\code{Field$new(descriptor, missingValues = list(""))}}{
#'Constructor to instantiate \code{Field} class.}
#' \itemize{
#'  \item{\code{descriptor }}{Schema field descriptor.}  
#'  \item{\code{missingValues }}{A list with vector strings representing missing values.}
#'  \item{\code{TableSchemaError }}{Raises any error occured in the process.}
#'  \item{\code{Field }}{Returns \code{Field} class instance.}
#'  }
#'   \item{\code{cast_value(value, constraints=TRUE)}}{
#'   Cast given value according to the field type and format.}
#' \itemize{
#'  \item{\code{value }}{Value to cast against field}  
#'  \item{\code{constraints  }}{ Gets constraints configuration: 
#'  it could be set to true to disable constraint checks, or 
#'  it could be a List of constraints to check}
#'  \item{\code{errors$TableSchemaError }}{Raises any error occured in the process}
#'  \item{\code{any }}{Returns cast value}
#'  }
#'  
#' \item{\code{testValue(value, constraints=TRUE)}}{
#'   Test if value is compliant to the field.}
#' \itemize{
#'  \item{\code{value }}{Value to cast against field}  
#'  \item{\code{constraints  }}{Constraints configuration}
#'  \item{\code{Boolean }}{Returns if value is compliant to the field}
#'  }
#' }
#' 
#' @section Properties:
#' \describe{
#'   \item{\code{name}}{Returns field name}
#'   \item{\code{type}}{Returns field type}
#'   \item{\code{format}}{Returns field format}
#'   \item{\code{required}}{Returns \code{TRUE} if field is required}
#'   \item{\code{constraints}}{Returns list with field constraints}
#'   \item{\code{descriptor}}{Returns field descriptor}
#' }
#'  
#' 
#' @details 
#' A field descriptor \code{MUST} be a JSON object that describes a single field. 
#' The descriptor provides additional human-readable documentation for a field, 
#' as well as additional information that may be used to validate the field or 
#' create a user interface for data entry.
#' 
#' The field descriptor \code{object} \code{MAY} contain any number of other properties. 
#' Some specific properties are defined below. Of these, only the \code{name} property is \code{REQUIRED}.
#' 
#' \describe{
#' \item{\code{name}}{
#' The field descriptor \code{MUST} contain a \code{name} property. 
#' This property \code{SHOULD} correspond to the name of field/column in the data file (if it has a name). 
#' As such it \code{SHOULD} be unique (though it is possible, but very bad practice, for the data file to 
#' have multiple columns with the same name). \code{name} \code{SHOULD NOT} be considered case sensitive in 
#' determining uniqueness. However, since it should correspond to the name of the field in the data file 
#' it may be important to preserve case.}
#' \item{\code{title}}{
#' A human readable label or title for the field.}
#' 
#' \item{\code{description}}{
#' A description for this field e.g. "The recipient of the funds".}
#' }
#' 
#' 
#' 
#' @section Language:
#' The key words \code{MUST}, \code{MUST NOT}, \code{REQUIRED}, \code{SHALL}, \code{SHALL NOT}, 
#' \code{SHOULD}, \code{SHOULD NOT}, \code{RECOMMENDED}, \code{MAY}, and \code{OPTIONAL} 
#' in this package documents are to be interpreted as described in \href{https://www.ietf.org/rfc/rfc2119.txt}{RFC 2119}.
#' 
#' 
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include types.R
#' @include constraints.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.
#' 
#' @seealso \href{http://frictionlessdata.io/specs/table-schema/#field-descriptors}{Field Descriptors Specifications}
#'  
#' @examples 
#' DESCRIPTOR = list(name = "height", type = "number")
#' 
#' field <- Field$new(descriptor = DESCRIPTOR)
#' 
#' # get correct instance
#' field$name
#' field$format
#' field$type
#' 
#' # return true on test
#' field$testValue(1)
#' 
#' # cast value
#' field$cast_value(1)
#' 
#' # expand descriptor by defaults
#' field <- Field$new(descriptor = list(name = "name"))
#' 
#' field$descriptor
#' 
#' 
#' # parse descriptor with "enum" constraint
#' field <- Field$new(descriptor = list(name = "status", type = "string", 
#'                    constraints = list(enum = list('active', 'inactive'))))
#' 
#' field$testValue('active')
#' field$testValue('inactive')
#' field$testValue('activia')
#' field$cast_value('active')
#' 
#' 
#' # parse descriptor with "minimum" constraint'
#' field <- Field$new(descriptor = list(name = "length", type = "integer", 
#'                    constraints = list(minimum = 100)))
#' 
#' field$testValue(200)
#' field$testValue(50)
#' 
#' 
#' # parse descriptor with "maximum" constraint'
#' field <- Field$new(descriptor = list(name = "length", type = "integer", 
#'                    constraints = list(maximum = 100)))
#' 
#' field$testValue(50)
#' field$testValue(200)
#' 

Field <- R6Class(
  "Field",
  public = list(
    initialize = function(descriptor,
                          base_path = NULL,
                          strict = NULL,
                          missingValues = as.list(config::get("DEFAULT_MISSING_VALUES", file = system.file("config/config.yml", package = "tableschema.r"))),
                          ...) {
      
      if (missing(base_path)) {
        private$base_path <- NULL
      }
      else {
        private$base_path <- base_path
      }
      if (missing(strict)) {
        private$strict <- NULL
      }
      else {
        private$strict <- strict
      }
      if (missing(descriptor)) {
        private$descriptor_ <- NULL
      }
      else {
        private$descriptor_ <- descriptor
      }
      
      
      private$missingValues <- missingValues
      
      private$descriptor_ = Helpers$expandFieldDescriptor(descriptor)
      
      
    },
    
    cast_value = function(...) {
      return(private$castValue(...))
    },
    testValue = function(value, constraints = TRUE) {
      result = tryCatch({
        private$castValue(value, constraints)
        
        TRUE
      }, warning = function(w) {
        return(FALSE)
        
      }, error = function(e) {
        return(FALSE)
        
      }, finally = {
        
      })
      
      return(result)
    }
  ),
  active = list(
    descriptor = function() {
      
      return(private$descriptor_)
      
    },
    
    required = function(){
      if (!is.null(private$descriptor_)) {
        return(identical(private$descriptor_$required, TRUE))
      }
      else{
        return(FALSE)
      }
    },
    name = function() {
      return(private$descriptor_$name)
    },
    type = function() {
      return(private$descriptor_$type)
    },
    format = function() {
      return(private$descriptor_$format)
    },
    constraints = function() {
      if (is.list(private$descriptor_) && "constraints"  %in% names(private$descriptor_))
      {
        return(private$descriptor_$constraints)
      }
      else {
        return(list())
      }
    }
  ),
  
  private = list(
    missingValues = NULL,
    base_path = NULL,
    strict = NULL,
    descriptor_ = NULL,
    types = Types$new(),
    constraints_ = Constraints$new()$constraints,
    
    castFunction = function() {
      options <- list()
      # Get cast options for number
      
      if (self$type == 'number') {
        lapply(list('decimalChar', 'groupChar', 'currency'), function(key) {
          value <- private$descriptor_[[key]]
          
          
          if (!is.null(value)) {
            options[[key]] = value
          }
        })
      }
      
      func <- private$types$casts[[stringr::str_interp("cast${stringr::str_to_title(self$type)}")]]
      if (is.null(func))
        stop(stringr::str_interp("Not supported field type ${self$type}"))
      cast <- purrr::partial(func, format = self$format)
      
      return(cast)
    },
    
    castValue = function(value, constraints = TRUE, ...) {
      
      if (value %in% private$missingValues) {
        value <- NULL
        
      }
      
      castValue <- value
      
      if (!is.null(value)) {
        
        castFunction <- private$castFunction()
        
        castValue = castFunction(value)
        if (identical(castValue , config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))) {
          err_message <-
            stringr::str_interp(
              "Field ${private$name} can't cast value ${value} for type ${self$type} with format ${self$format}"
            )
          stop(err_message)
        }
      }
      
      
      if (constraints || is.list(constraints)) {
        
        checkFunctions = private$checkFunctions()
        
        if (is.list(checkFunctions) &
            length(checkFunctions) > 0) {
          names_ = Filter(function(n) {
            if (!is.list(constraints)) {
              return(TRUE)
            }
            else if (n %in% names(constraints)) {
              return(TRUE)
            }
            else
              return(FALSE)
            
          }, names(checkFunctions))
          
          
          lapply(checkFunctions[names_],
                 function(check) {
                   
                   passed = check(castValue)
                   
                   if (!passed) {
                     err_message <-
                       stringr::str_interp(
                         "Field ${private$name} has constraint ${name} which is not satisfied for value ${value}"
                       )
                     stop(err_message)
                   }
                   
                 })
        }
      }
      return(castValue)
    },
    checkFunctions = function() {
      
      checks = list()
      cast <-
        purrr::partial(private$castValue, constraints = FALSE)
      
      for (name in names(self$constraints)) {
        constraint = self$constraints[[name]]
        castConstraint <- constraint
        if (name %in% list('enum')) {
          castConstraint <- lapply(constraint, cast)
        }
        if (name %in% list('maximum', 'minimum')) {
          castConstraint <- cast(constraint)
        }
        
        func <- private$constraints_[[stringr::str_interp("check${stringr::str_to_title(name)}")]]
        check <- purrr::partial(func, constraint = castConstraint)
        checks[[name]] = check
      }
      return(checks)
    }
  )
)
