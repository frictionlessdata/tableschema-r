#' @title cast date
#' 
#' @rdname types.castDate
#' @export
#' @description cast date
#' 
types.castDate <- function (format = "%y-%m-%d", value) {
  
  if ( !is.date(lubridate::as_date(value, format = format)) ) {
    
    if( !is.character(value) ) value = stop("Value should be character or date class")
  
    tryCatch({
      if (format == "%y-%m-%d"){
        
        value = lubridate::as_date(lubridate::parse_date_time(value, format))
                
      } else if (format != "%y-%m-%d") {
        
        value = lubridate::as_date(value, format) 
        
      } else {
        
        if (all(startsWith(format,"fmt:")) ){
          
          warning( sprintf("Format %s is deprecated.\nPlease use '%s' without 'fmt:' prefix.", format, unlist(strsplit(format,":"))[2]) )
          
          format = trimws(gsub("fmt:","",format),which="both")
        }
        
        value = lubridate::as_date(lubridate::parse_date_time(value, format))
      }
      
      if (!is.date(lubridate::as_date(value, format = format) )) value =  stop("Value is not a valid date")
    
      value = lubridate::as_date(value) 
      
      },error = function(e)  err <<- e
      )
  }
  return(value)
}



#' Check if date is a valid date
#' @rdname is.date
#' @export
is.date <- function (date, format="%y/%m/%d") {
  
  withCallingHandlers(
    tryCatch(
    
    !is.na(lubridate::as_date(lubridate::parse_date_time(date , format ))), error = function(e) {FALSE}
    )  ,warning=function(w) {
             warn <<- w
             invokeRestart("muffleWarning")
    })
  
}
