library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

context("constraints.checkUnique")

# Constants

TESTS = list(
  
  list(FALSE, "any", TRUE),
  
  list(TRUE, "any", TRUE),
  
  list(TRUE, "other", TRUE)
  
)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("constraint", "value", "result"))
  
  test_that(str_interp('constraint "${TESTS[[j]]$constraint}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(constraints.checkUnique(TESTS[[j]]$constraint, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
