#' ReadableArray class
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include constraints.R
#' @include tableschemaerror.R
#' @include profile.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.
ReadableArray <- R6Class(
  "ReadableArray",
  inherit = Readable,
  public = list(
    initialize = function(options = list()) {

      private$array_ = options$source;
      
    },
    
    iterable = function(){

      return(iterators::iter(function(){
        if (private$index_ <= length(private$array_)) {
          value = private$array_[[private$index_]]
          private$index_ = private$index_ + 1
          return(value)
        }
        else {
          stop('StopIteration')
        }

      }))
    }
    
    
    
   
  ),
 
  private = list(
    
    index_ = 1,
    
    array_ = list(),
  
    read_ = function(size) {
      return(private$array_)
    },
    destroy_ = function() {
      
    }
 
    

)
)
