#' @title Field class
#'
#' @description Class representing a field in the schema.
#'
#' Data values can be cast to native R types. Casting a value checks whether it is of the expected type, in the correct format, and compliant with any constraints imposed by the schema.
#'
#' @usage
#' # Field$new(descriptor, missingValues = list(""))
#'
#' @param descriptor Schema field descriptor.
#' @param missingValues A list with vector strings representing missing values.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{Field$new(descriptor, missingValues = list(""))}}{Constructor to instantiate the \code{Field} class. Accepts the following arguments:
#'     \describe{
#'       \item{\code{descriptor}}{Schema field descriptor.}
#'       \item{\code{missingValues}}{A list of strings representing missing values.}
#'       \item{\code{TableSchemaError}}{Raised if an error occurs during instantiation.}
#'       \item{\code{Field}}{Returns a \code{Field} class instance.}
#'     }
#'   }
#'
#'   \item{\code{cast_value(value, constraints = TRUE)}}{Casts a given value according to the field's type and format.
#'     \describe{
#'       \item{\code{value}}{Value to cast.}
#'       \item{\code{constraints}}{Logical or list of constraints to apply.}
#'       \item{\code{errors$TableSchemaError}}{Raised if casting fails due to a constraint violation.}
#'       \item{\code{any}}{Returns the cast value.}
#'     }
#'   }
#'
#'   \item{\code{testValue(value, constraints = TRUE)}}{Tests if a value complies with the field definition.
#'     \describe{
#'       \item{\code{value}}{Value to test.}
#'       \item{\code{constraints}}{Constraints configuration.}
#'       \item{\code{Boolean}}{Returns \code{TRUE} if the value is compliant.}
#'     }
#'   }
#' }
#'
#' @section Properties:
#' \describe{
#'   \item{\code{name}}{Returns the field name.}
#'   \item{\code{type}}{Returns the field type.}
#'   \item{\code{format}}{Returns the field format.}
#'   \item{\code{required}}{Returns \code{TRUE} if the field is required.}
#'   \item{\code{constraints}}{Returns a list of field constraints.}
#'   \item{\code{descriptor}}{Returns the field descriptor.}
#' }
#'
#' @details
#' A field descriptor \code{MUST} be a JSON object that describes a single field. The descriptor provides both human-readable documentation and machine-readable validation rules. It may also guide user interface generation for data entry.
#'
#' The descriptor \code{object} \code{MAY} include additional custom properties. Of these, only the \code{name} property is \code{REQUIRED}.
#'
#' \describe{
#'   \item{\code{name}}{The descriptor \code{MUST} contain a \code{name} property, typically corresponding to the column name in the data file. This name \code{SHOULD} be unique, and while not case-sensitive for uniqueness, preserving case is advisable.}
#'   \item{\code{title}}{A human-readable label for the field.}
#'   \item{\code{description}}{A text description of the field, e.g., "The recipient of the funds".}
#' }
#'
#' @section Language:
#' The key words \code{MUST}, \code{MUST NOT}, \code{REQUIRED}, \code{SHALL}, \code{SHALL NOT}, \code{SHOULD}, \code{SHOULD NOT}, \code{RECOMMENDED}, \code{MAY}, and \code{OPTIONAL} in this documentation are to be interpreted as described in \href{https://www.ietf.org/rfc/rfc2119.txt}{RFC 2119}.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include types.R
#' @include constraints.R
#' @keywords data
#' @return Object of class \code{\link{R6Class}}.
#' @format \code{\link{R6Class}} object.
#'
#' @seealso \href{https://specs.frictionlessdata.io//table-schema/#field-descriptors}{Field Descriptors Specifications}
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
      
      private$descriptor_ <- helpers.expandFieldDescriptor(descriptor)
      
      
    },
    
    cast_value = function(...) {
      return(private$castValue(...))
    },
    testValue = function(value, constraints = TRUE) {
      result <- tryCatch({
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
            options[[key]] <- value
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
        
        castValue <- castFunction(value)
        if (identical(castValue , config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))) {
          err_message <-
            stringr::str_interp(
              "Field ${private$name} can't cast value ${value} for type ${self$type} with format ${self$format}"
            )
          stop(err_message)
        }
      }
      
      
      if (constraints || is.list(constraints)) {
        
        checkFunctions <- private$checkFunctions()
        
        if (is.list(checkFunctions) &
            length(checkFunctions) > 0) {
          names_ <- Filter(function(n) {
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
                   
                   passed <- check(castValue)
                   
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
      
      checks <- list()
      cast <-
        purrr::partial(private$castValue, constraints = FALSE)
      
      for (name in names(self$constraints)) {
        constraint <- self$constraints[[name]]
        castConstraint <- constraint
        if (name %in% list('enum')) {
          castConstraint <- lapply(constraint, cast)
        }
        if (name %in% list('maximum', 'minimum')) {
          castConstraint <- cast(constraint)
        }

        func <- private$constraints_[[stringr::str_interp("check${paste0(toupper(substr(name, 1, 1)), substr(name, 2, nchar(name)))}")]]
        check <- purrr::partial(func, constraint = castConstraint)
        checks[[name]] <- check
      }
      return(checks)
    }
  )
)
