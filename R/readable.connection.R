#' ReadableConnection class
#' @description Readable connection class
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include constraints.R
#' @include tableschemaerror.R
#' @include profile.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.
ReadableConnection <- R6Class(
  "ReadableConnection",
  inherit = Readable,
  public = list(
    initialize = function(options = list()) {

      private$connection_ <- options$source
      
    },
    
    iterable = function() {
      
      open(private$connection_)
      return(iterators::iter(function(){
        if (length(oneLine <- readLines(private$connection_, n = 1, warn = FALSE)) > 0) {
          numfields <- count.fields(textConnection(oneLine), sep = ";")
          if (numfields[[1]] == 1) delim <- ',' else delim <- ';'

          value <- as.list(strsplit(x = oneLine,
                   split =  paste0(delim,'(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))'),
                   perl = TRUE)[[1]])
          
          
          # value <- as.list((strsplit(oneLine, delim))[[1]])
          private$index_ <- private$index_ + 1

          return(value)
          
        }
       
        else {
          close(private$connection_)
          stop('StopIteration')
        }

      },by = 'row'))
    }
    
    
    
   
  ),
 
  private = list(
    
    index_ = 1,
    
    connection_ = NULL,
  
    read_ = function(size) {
      return(private$connection_)
    },
    destroy_ = function() {
      close.connection(private$connection_)
    }
 
    

)
)
