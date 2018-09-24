library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

context("constraints.checkMinLength")

# Constants
TESTS <- list(
  
  list( 0, list(1),  TRUE),
  
  list( 1, list(1),  TRUE),
  
  list( 2, list(1),  FALSE),
  
  list( 2, NULL,  TRUE)
  
)

# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("constraint", "value", "result"))
  
  test_that(str_interp('constraint "${TESTS[[j]]$constraint}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(constraints.checkMinLength(TESTS[[j]]$constraint, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
