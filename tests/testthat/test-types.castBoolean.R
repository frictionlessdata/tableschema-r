library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(config)

context("types.castBoolean")

# Constants

TESTS <- list(
  
  list("default", TRUE, TRUE, {} ),
  list("default", "true", TRUE, {} ),
  list("default", "True", TRUE, {} ),
  list("default", "TRUE", TRUE, {} ),
  list("default", "1", TRUE,{} ),
  list("default", "yes", TRUE, list(trueValues = list("yes")) ),
  list("default", "Y", TRUE, list(trueValues = list("Y")) ),
  
  list("default", FALSE, FALSE, {} ),
  list("default", "false", FALSE, {} ),
  list("default", "False", FALSE, {} ),
  list("default", "FALSE", FALSE, {} ),
  list("default", "0", FALSE, {}),
  list("default", "no", FALSE, list(falseValues = list("no")) ),
  list("default", "N", FALSE, list(falseValues = list("N")) ),
  
  list("default", "YES", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "Yes", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "yes", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "y", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "t", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "f", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "no", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "n", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "NO", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "No", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  
  list("default", "N", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), list(falseValues = list("n"))),
  list("default", "Y", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), list(falseValues = list("y"))),
  
  list("default", 0, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", 1, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "3.14", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} ),
  list("default", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")), {} )
)

# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("format", "value", "result", "options"))
  
  test_that(str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castBoolean(TESTS[[j]]$format, TESTS[[j]]$value, TESTS[[j]]$options), TESTS[[j]]$result)
  })
}
