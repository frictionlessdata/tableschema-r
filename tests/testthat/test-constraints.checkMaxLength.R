library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

testthat::context("constraints.checkMaxLength")

# Constants
TESTS = list(
  
  list( 0, list(1),  FALSE),
  
  list( 1, list(1),  TRUE),
  
  list( 2, list(1),  TRUE)
  
)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("constraint", "value", "result"))
  
  test_that(stringr::str_interp('constraint "${TESTS[[j]]$constraint}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(constraints.checkMaxLength(TESTS[[j]]$constraint, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}

