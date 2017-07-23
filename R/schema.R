#' @export

library(R6)

Schema <- R6Class("Schema",
    public = list(
        valid = NULL, 
        errors = list(), 
        descriptor = list(), 
        primary_key = list(), 
        foreign_keys = list(), 
        fields = list(), 
        field_names = list(), 
  
        add_field = function(...) {}, 
        remove_field = function(...) {}, 
        get_field = function(...) {}, 
        cast_row = function(...) {}, 
        update = function(...) {}, 
        save = function(...) { }
      ),
      active = list(
        
            
      )
  )