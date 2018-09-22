#' Readable class
#' @description Readable class that allows typed access to its members
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include constraints.R
#' @include tableschemaerror.R
#' @include profile.R
#' @keywords data
#' @return Object of \code{\link{R6Class}}.
#' @format \code{\link{R6Class}} object.
#' 

Readable <- R6Class(
  "Readable",
  
  public = list(
    initialize = function(options = list()) {
    },
    
    read = function(size = NULL) {
      future::future( {
        while (TRUE) {
          if (length(private$buffer_) < 3) {
            
            chunk = private$read_(size)
            private$buffer_ = rlist::list.append(private$buffer_, chunk)
          }
        }
      })
    },
    
    pipe = function(destination, options = list()) {
      private$pipeDestination_ = destination
      self$read();
      
      destination$on.drain = private$pipeDrained_
      
      private$flowing_ = TRUE;
      return(destination)
      
    },
    unpipe = function(destination) {
      
    },
    pause = function() {
      
    },
    resume = function() {
      
    },
    setEncoding = function() {
      
    },
    isPaused = function() {
      
    },
    unshift = function(chunk) {
    },
    destroy = function() {
      private$destroy_()
    },
    
    push = function(chunk, encoding) {
      
    },
    
    onData = function(chunk){
      if (private$flowing_) {
      }
    },
    
    on.close = function(handler, unsubscribe = FALSE) {
      private$subscribeUnsubscribe_('close', handler, unsubscribe)
    },
    
    on.data = function(handler, unsubscribe = FALSE) {
      private$subscribeUnsubscribe_('data', handler, unsubscribe)
    },
    
    on.end = function(handler, unsubscribe = FALSE) {
      private$subscribeUnsubscribe_('end', handler, unsubscribe)
    },
    
    on.error = function(handler, unsubscribe = FALSE) {
      private$subscribeUnsubscribe_('error', handler, unsubscribe)
    },
    
    on.readable = function(handler, unsubscribe = FALSE) {
      private$subscribeUnsubscribe_('readable', handler, unsubscribe)
    }
  ),
  
  active = list(
    destroyed = function(value) {
    }
  ),
  
  private = list(
    encoding_ = NULL,
    objectMode_ = FALSE,
    read_ = function() {
      browser()
    },
    destroy_ = function() {
      
    },
    buffer_ = list(),
    readable_ = TRUE,
    paused_ = TRUE,
    pipeDestination_ = list(),
    flowing_ = FALSE,
    
    pipeDrained_ = function(){
      chunk = private$buffer[[1]]
      rlist::list.remove(private$buffer,1)
      private$pipeDestination$write(chunk)
    },
    
    eventHandlers_ = list(
      'close' = list(),
      data = list(),
      end = list(),
      error = list(),
      readable = list()
    ),
    
    emit_ = function(event, arguments = list()) {
      for (handler in private$eventHandlers_[[event]]) {
        handler(arguments)
      }
    },
    subscribeUnsubscribe_ = function(event, handler, unsubscribe = FALSE) {
      if (!unsubscribe) {
        rlist::list.append(private$eventHandlers_[[event]], handler)
      }
      else {
        rlist::list.remove(private$eventHandlers_[[event]], function(eventHandler) {
          return(identical(eventHandler, handler))
        })
      }
    }
  )
)
