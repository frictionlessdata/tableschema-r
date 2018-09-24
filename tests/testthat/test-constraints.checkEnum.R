library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

context("constraints.checkEnum")

# Constants
TESTS <- list(
  
  list( list(1, 2), 1,  TRUE),
  
  list( list(0, 2), 1,  FALSE),
  
  list( list(), 1,  FALSE),
  
  list( list(), NULL,  TRUE)
  
)

# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("constraint", "value", "result"))

  test_that(str_interp('constraint "${TESTS[[j]]$constraint}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
       
       expect_equal(constraints.checkEnum(TESTS[[j]]$constraint, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
