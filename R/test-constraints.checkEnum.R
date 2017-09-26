library(stringr)
library(tableschema.r)
library(testthat)

# Constants

TESTS = list(
  
  list( list(1, 2), 1, TRUE),
  
  list( list(0, 2), 1, FALSE),
  
  list( list(), 1, FALSE)
  
  )
testthat::context("checkEnum")

# Tests

purrr::map(TESTS,function(test) {
  
  test= list(constraint=NULL, value=NULL, result=NULL)
  
  test_that(stringr::str_interp('constraint "${constraint}" should check "${value}" as "${result}"`'), function() {
    
    expect_equal(constraints.checkEnum(constraint, value), result)
  })
  
})
