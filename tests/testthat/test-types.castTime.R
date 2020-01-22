library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(lubridate)
library(config)

context("types.castTime")

Time <- function(hour, minute=0, second=0) {
  value <- lubridate::as_datetime(lubridate::make_datetime(0, 0, 1, hour, minute, second,tz = "UTC"))
  unlist(strsplit(as.character(value), " "))[[2]]
}

# Constants

TESTS <- list(
  
  list('default', Time(6), Time(6)),
  list('default', '06:00:00', Time(6)),
  list('default', '09:00', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('default', '3 am', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('default', '3.00', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('default', 'invalid', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('default', TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('default', '', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('any', Time(6), Time(6)),
  ### list(/ ['any', '06:00:00', Time(6)),
  ### list(/ ['any', '3:00 am', Time(3)),
  list('any', 'some night', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('any', 'invalid', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('any', TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('any', '', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('%H:%M', Time(6), Time(6)),
  # list('%H:%M', '06:00', Time(6)),
  ### list(/ ['%M:%H', '06:50', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  # list('%H:%M', '3:00 am', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('%H:%M', 'some night', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('%H:%M', 'invalid', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('%H:%M', TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('%H:%M', '', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('invalid', '', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  ### list(/ Deprecat)d
  # list('fmt:%H:%M', Time(6), Time(6)),
  # list('fmt:%H:%M', '06:00', Time(6)),
  # list(/ ['fmt:%M:%H', '06:50', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('fmt:%M:%H', '06:50', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  # list(/ ['fmt:%M:%H', '06:50', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  # list('fmt:%H:%M', '3:00 am', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('fmt:%H:%M', 'some night', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('fmt:%H:%M', 'invalid', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('fmt:%H:%M', TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('fmt:%H:%M', '', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
)

# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castTime(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
