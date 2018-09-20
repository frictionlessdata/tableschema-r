library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)

testthat::context("types.castArray")

# Constants
TESTS = list(
  list('default', list(), list()),
  list('default', list(), list()),
  list('default', list('key', 'value'), list('key', 'value')),
  list('default', '["key", "value"]', list('key', 'value')),
  list('default', 'string', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('default', 1, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('default', '3.14', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('default', '', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(stringr::str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castArray(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
