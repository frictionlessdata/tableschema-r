library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)



# Tests

testthat::context("TableSchemaError")


  test_that('should work with one error', {
    error = TableSchemaError$new('message')
    expect_equal(error$message, 'message')
    expect_equal(error$multiple, FALSE)
    expect_equal(error$errors, list())
  })
  
  test_that('should work with multiple errors', {
    errors = list(Error = 'error1', Error = 'error2')
    error = TableSchemaError$new('message', errors)
    expect_equal(error$message, 'message')
    expect_equal(error$multiple, TRUE)
    expect_equal(length(error$errors), 2)
    expect_equal(error$errors[[1]], 'error1')
    expect_equal(error$errors[[2]], 'error2')
  })
  
  test_that('should be catchable as a normal error', {
    
    error= withCallingHandlers(
      
      tryCatch(
        TableSchemaError$new('message'), 
        error=function(e) {
          err <<- e
          NULL
        }), 
      warning=function(w) {
        warn <<- w
        invokeRestart("muffleWarning")
      })

    
    expect
      expect_equal(error$message, 'message')
      expect_true(inherits(error,"TableSchemaError"))
    })

  