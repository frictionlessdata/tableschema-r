library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

testthat::context("types.castString")

# Constants

TESTS = list(
  list("default", "string", "string"),
  list("default", "", ""),
  list("default", 0, config::get("ERROR")),
  list("uri", "http://google.com", "http://google.com"),
  list("uri", "string", config::get("ERROR")),
  list("uri", "", config::get("ERROR")),
  list("uri", 0, config::get("ERROR")),
  list("email", "name@gmail.com", "name@gmail.com"),
  list("email", "http://google.com", config::get("ERROR")),
  list("email", "string", config::get("ERROR")),
  list("email", "", config::get("ERROR")),
  list("email", 0, config::get("ERROR")),
  list("binary", "dGVzdA==", "dGVzdA=="),
  list("binary", "", ""),
  #list("binary", "string", config::get("ERROR")),
  list("binary", 0, config::get("ERROR"))
)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(stringr::str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castString(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
