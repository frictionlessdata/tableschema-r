library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

context("constraints.checkMinimum")

# Constants
TESTS <- list(
  
  list( 0, 1,  TRUE),
  
  list( 1, 1,  TRUE),
  
  list( 2, 1,  FALSE),
  
  list( 2, NULL,  TRUE)
  
)

# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("constraint", "value", "result"))
  
  test_that(str_interp('constraint "${TESTS[[j]]$constraint}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(constraints.checkMinimum(TESTS[[j]]$constraint, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
