library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(config)

context("types.castGeojson")

# Constants

TESTS <- list(
  
  ## list('default',
  ##   {'properties': {'Ã': 'Ã'}, 'type': 'Feature', 'geometry': NULL},
  ##   {'properties': {'Ã': 'Ã'}, 'type': 'Feature', 'geometry': NULL} ),
  
  ## list('default',
  ##  '{"geometry": null, "type": "Feature", "properties": {"\\u00c3": "\\u00c3"}}',
  ##  {'properties': {'Ã': 'Ã'}, 'type': 'Feature', 'geometry': NULL} ),
  
  list('default', "{'coordinates': [0, 0, 0], 'type': 'Point'}", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")) ),
  list('default', 'string', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")) ),
  list('default', 1, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")) ),
  list('default', '3.14', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")) ),
  list('default', '', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")) ),
  list('default', {}, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")) ),
  list('default', '{}', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")) ),
  
  #list('topojson', "{'type': 'LineString', 'arcs': [42]}","{'type': 'LineString', 'arcs': [42]}" ),

  #list('topojson', '{"type": "LineString", "arcs": [42]}',{'type': 'LineString', 'arcs': [42]} ),

  list('topojson', list("arcs" = list(42)), config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('topojson', 'string', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('topojson', 1, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('topojson', '3.14', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  list('topojson', '', config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")) )
)

# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castGeojson(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
