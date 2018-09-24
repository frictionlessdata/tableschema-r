#' Writeable class
#' @description Writable streams class
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @include constraints.R
#' @include tableschemaerror.R
#' @include profile.R
#' @keywords data
#' @return Object of \code{\link{R6Class}} .
#' @format \code{\link{R6Class}} object.
#' 

Writeable <- R6Class(
  "Writeable",
  
  public = list(
    initialize = function(options = list()) {
      
      private$drain_()
    },
    
    write = function(chunk){
      private$buffer_ <- rlist::list.append(private$buffer_, chunk)
    },
    
    
    read = function(size = NULL) {
      
    },
    pipe = function(destination, options = list()) {
      
      
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
      
    },
    
    push = function(chunk, encoding) {
      
    },
    
    on.drain = NULL,
    
    onClose = function(handler, unsubscribe = FALSE) {
      private$subscribeUnsubscribe_('close', handler, unsubscribe)
    },
    
    onData = function(handler, unsubscribe = FALSE) {
      private$subscribeUnsubscribe_('data', handler, unsubscribe)
    },
    
    onEnd = function(handler, unsubscribe = FALSE) {
      private$subscribeUnsubscribe_('end', handler, unsubscribe)
    },
    
    onError = function(handler, unsubscribe = FALSE) {
      private$subscribeUnsubscribe_('error', handler, unsubscribe)
    },
    
    onReadable = function(handler, unsubscribe = FALSE) {
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
    drain_ = function() {
      future::future( {
        while (TRUE) {
          if (length(private$buffer_) > 0) {
            chunk <- private$buffer_[[1]]
            private$buffer_ <- rlist::list.remove(private$buffer_, 1)
            print(chunk)
          }
          else{
            self$on.drain()
          }
        }
      })
    },
    destroy_ = function() {
      
    },
    buffer_ = list(),
    readable_ = TRUE,
    paused_ = TRUE,
    pipeDestinations_ = list(),
    
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
