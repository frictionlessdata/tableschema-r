library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(config)

context("types.castDate")

# Constants

TESTS <- list(
  
  list("default", as.Date("2019-1-1"), as.Date("2019-1-1")),

  list("default", "2019-01-01", as.Date("2019-1-1")),

  list("default", "10th Jan 1969", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("default", "invalid", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("default", TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("default", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("any", as.Date("2019-1-1"), as.Date("2019-1-1")),

  list("any", "2019-01-01", as.Date("2019-1-1")),

  #list ("any", "10th Jan 1969", as.Date("1969-1-10")),

  list("any", "10th Jan nineteen sixty nine", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("any", "invalid", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("any", TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("any", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("%d/%m/%y", as.Date("2019-1-1"), as.Date("2019-1-1")),

  list("%d/%m/%y", "21/11/06", as.Date("2006-11-21")),

  list("%y/%m/%d", "21/11/06 16:30", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("%d/%m/%y", "invalid", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("%d/%m/%y", TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("%d/%m/%y", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("invalid", "21/11/06 16:30", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("invalid", as.Date("2019-1-1"), as.Date("2019-1-1")),
  
  # Deprecated
  list("fmt:%d/%m/%y", as.Date("2019-1-1"), as.Date("2019-1-1")),

  list("fmt:%d/%m/%y", "21/11/06", as.Date("2006-11-21")),

  list("fmt:%y/%m/%d", "21/11/06 16:30", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("fmt:%d/%m/%y", "invalid", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("fmt:%d/%m/%y", TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("fmt:%d/%m/%y", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))

)


# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castDate(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
