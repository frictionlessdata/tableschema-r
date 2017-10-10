library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

testthat::context("types.castYearmonth")


# Constants

TESTS = list(
  
  list("default", list(2000, 10), list(2000, 10)),
  
  list("default", "2000-10", list(2000, 10)),
  
  list("default", list(2000, 10, 20), config::get("ERROR")),
  
  list("default", "2000-13-20", config::get("ERROR")),
  
  list("default", "2000-13", config::get("ERROR")),
  
  list("default", "2000-0", config::get("ERROR")),
  
  list("default", "13", config::get("ERROR")),
  
  list("default", -10, config::get("ERROR")),
  
  list("default", 20, config::get("ERROR")),
  
  list("default", "3.14", config::get("ERROR")),
  
  list("default", "", config::get("ERROR"))
  
)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(stringr::str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castYearmonth(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
