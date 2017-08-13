#' @title get descriptor
#' @description get descriptor
#' @usage get.descriptor.path(directory= ".")
#' @param directory A character vector of full path name. The default corresponds to the working directory specified by /code{/link[base]{getwd}}
#' @rdname get.descriptor.path
#' @export

get.descriptor.path <- function(directory= ".") {
  
  # datapackage.json(descriptor) exists?
  
  files = list.files(path = directory, recursive = FALSE)
  
  exist = grepl("datapackage.json", files, fixed = FALSE, ignore.case = FALSE)
  
  if ( any(exist) == TRUE ) {
    
    descriptor.path = path.expand(paste0(directory,"/datapackage.json"))
    
    descriptor.path
    
  } else message("Descriptor file (datapackage.json) does not exists.")
  
}

#get.descriptor.path('C:/Users/Kleanthis-Okf/Documents/datapackage-r/a/gdp-master')


#' @title filepath
#' @description filepath
#' @param x x
#' @rdname filepath
#' @export

filepath <- function(x){
  
  files = list.files(recursive = TRUE)
  
  matched_files = files[ grep(x, files,fixed = FALSE, ignore.case = F) ]
  
  if ( length(matched_files) > 1 ){
    
    message("There are multiple matches with the input file." ) 
    
    choice = utils::menu(matched_files, title = cat("Please specify the input file:"))
    
    matched_files = matched_files[choice]
    
  } # else 
    
    return (matched_files)
}
