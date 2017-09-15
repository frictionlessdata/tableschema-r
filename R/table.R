#' @export


Table <- R6Class(
  "Table",
  public = list(
    initialize = function(src, schema = NULL) {
      if (missing(schema)) {
        
      }
      else {
        self$schema <- schema
      }
      
      
      private$src <- src
      
    },
    iter = function(...) {
      
    },
    read = function(...) {
      
    },
    save = function(...) {
      
    }
  ),
  active = list(
    schema = function(value) {
      if (missing(value)) {
        private$schema_
      }
      else {
        private$schema_ <- value
      }
    },
    headers = function() {
      list()
    }
    
  ),
  private = list(src = NULL,
                 schema_ = NULL)
  
)