library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(config)

context("types.castString")

# Constants

TESTS <- list(
  list("default", "string", "string"),
  list("default", "", ""),
  list("default", 0, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("uri", "http://google.com", "http://google.com"),
  list("uri", "://no-scheme.test", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("uri", "string", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("uri", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("uri", 0, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("email", "name@gmail.com", "name@gmail.com"),
  list("email", "http://google.com", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("email", "string", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("email", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("email", 0, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  list("uuid", '95ecc380-afe9-11e4-9b6c-751b66dd541e', '95ecc380-afe9-11e4-9b6c-751b66dd541e'),
  list("uuid", '0a7b330a-a736-35ea-8f7f-feaf019cdc00', '0a7b330a-a736-35ea-8f7f-feaf019cdc00'),
  list("uuid", '0a7b330a-a736-35ea-8f7f-feaf019cdc', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("uuid", "string", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("uuid", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("uuid", 0, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),

  
  list("binary", "YXN1cmUu", "YXN1cmUu"),
  list("binary", "c3VyZS4=", "c3VyZS4="),
  list("binary", "dGVzdA==", "dGVzdA=="),
  list("binary", "string", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("binary", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list("binary", 0, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
)

# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castString(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
