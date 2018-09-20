library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(config)

context("types.castYearmonth")


# Constants

TESTS = list(
  
  list("default", list(2000, 10), list(2000, 10)),
  
  list("default", "2000-10", list(2000, 10)),
  
  list("default", list(2000, 10, 20), config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", "2000-13-20", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", "2000-13", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", "2000-0", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", "13", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", -10, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", 20, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", "3.14", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castYearmonth(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
