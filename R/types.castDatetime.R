#' @title cast date time
#' @description cast date time
#' @param format specify format, default is "\%Y-\%m-\%dT\%H:\%M:\%SZ"
#' @param value value
#' @rdname types.castDatetime
#' @export
#' 
#format.Date(strptime(value, format="%Y-%m-%dT%H:%M:%SZ"), orders = "%Y-%m-%dT%H:%M:%SZ")
types.castDatetime <- function (format = "%Y-%m-%dT%H:%M:%SZ", value) {

  if (!lubridate::is.Date(value) ) {

    if (!is.character(value)) return(config::get("ERROR"))
    value = tryCatch({
      if (format == 'default'){
        value = lubridate::as_date(lubridate::fast_strptime(value, "%Y-%m-%dT%H:%M:%SZ" ))

      }
      else if (format == 'any') {
        
        value = as.Date(value)

      }
      
      else{
        if (startsWith(format, 'fmt:')){
          format = gsub('fmt:', '', format)
        }
        value =  lubridate::as_date(lubridate::fast_strptime(value, format))

        
      }
      
      if (is.na(value)) {
        return(config::get("ERROR"))

      }

      return(value)
      
    },
    
    warning = function(w) {

      return(config::get("ERROR"))
      
    },
    
    error = function(e) {

      return(config::get("ERROR"))
      
      invokeRestart("muffleWarning")
    }
    )
    
  }
  
  return(value)
}
