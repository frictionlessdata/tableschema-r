library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

testthat::context("constraints.checkRequired")

# Constants

TESTS = list(
  
  list(FALSE, 1, TRUE),
  
  list(TRUE, 0, TRUE),
  
  list(TRUE, NULL, FALSE),
  
  list(TRUE, "undefined", FALSE)
  
)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("constraint", "value", "result"))
  
  test_that(stringr::str_interp('constraint "${TESTS[[j]]$constraint}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(constraints.checkRequired(TESTS[[j]]$constraint, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
