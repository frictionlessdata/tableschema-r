library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(lubridate)

testthat::context("types.castDate")

# Constants

TESTS = list(
  
  list("default", as.Date("2019-1-1"), as.Date("2019-1-1")),

  list("default", "2019-01-01", as.Date("2019-1-1")),

  #list("default", "10th Jan 1969", config::get("ERROR")),

  #list("default", "invalid", config::get("ERROR")),

  list("default", TRUE, config::get("ERROR")),

  list("default", "", config::get("ERROR")),

  list("any", as.Date("2019-1-1"), as.Date("2019-1-1")),

  list("any", "2019-01-01", as.Date("2019-1-1")),

  # ["any", "10th Jan 1969", date(1969, 1, 10)),

  #list("any", "10th Jan nineteen sixty nine", config::get("ERROR")),

  #list("any", "invalid", config::get("ERROR")),

  list("any", TRUE, config::get("ERROR")),

  list("any", "", config::get("ERROR")),

  list("%d/%m/%y", as.Date("2019-1-1"), as.Date("2019-1-1")),

  list("%d/%m/%y", "21/11/06", as.Date("2006-11-21")),

  #list("%y/%m/%d", "21/11/06 16:30", config::get("ERROR")),

  #list("%d/%m/%y", "invalid", config::get("ERROR")),

  list("%d/%m/%y", TRUE, config::get("ERROR")),

  list("%d/%m/%y", "", config::get("ERROR")),

  list("invalid", "21/11/06 16:30", config::get("ERROR")),

  # Deprecated
  list("fmt:%d/%m/%y", as.Date("2019-1-1"), as.Date("2019-1-1")),

  list("fmt:%d/%m/%y", "21/11/06", as.Date("2006-11-21")),

  #list("fmt:%y/%m/%d", "21/11/06 16:30", config::get("ERROR")),

  #list("fmt:%d/%m/%y", "invalid", config::get("ERROR")),

  list("fmt:%d/%m/%y", TRUE, config::get("ERROR")),

  list("fmt:%d/%m/%y", "", config::get("ERROR"))

)

# Tests

foreach(j = 1:length(TESTS) ) %do% {
  
  TESTS[[j]] = setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(stringr::str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castDate(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
