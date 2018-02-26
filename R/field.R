#' Field class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include types.R
#' @include constraints.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.

Field <- R6Class(
  "Field",
  public = list(
    initialize = function(descriptor,
                          base_path = NULL,
                          strict = NULL,
                          missingValues = as.list(config::get("DEFAULT_MISSING_VALUES")),
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
      if (!is.null(private$descriptor_)){
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
        if (identical(castValue , config::get("ERROR"))) {
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
