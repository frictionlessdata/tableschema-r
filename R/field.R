library(R6)

Field <- R6Class("Field", public = list(
  name = NULL, 
  type = NULL, 
  format = NULL, 
  required = NULL, 
  constraints = NULL, 
  descriptor = NULL, 
  
  cast_value = function(...) {}, 
  test_value = function(...) { },
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