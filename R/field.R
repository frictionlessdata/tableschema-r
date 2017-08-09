#' @title field object
#' 
#' @description ...
#' 
#' @field descriptor  
#' @field missing_values = ['']
#' 
#' @importFrom R6 R6Class
#' 
#' @export

Field <- R6Class("Field",portable=TRUE, public = list(
  name = NULL, 
  type = NULL, 
  format = NULL, 
  required = NULL, 
  constraints = NULL, 
  descriptor = NULL, 
  
  cast_value = function(value, constraints=TRUE) {}, 
  test_value = function(value, constraints=TRUE) {},
print = function(...) {
    args = list(...);
    fields = NULL;
    to.print = list();
    if (is.null(args$fields)) {
        fields = names(get(class(self))$public_fields)
    } else {
        fields = args$fields
    }
    for (f in fields) {
        if (R6::is.R6(self[[f]])) {
            to.print[[f]] = self[[f]]$print()
        }
        else {
            to.print[[f]] = self[[f]]
        }

    }
    print(to.print);
},



  ) 

  )