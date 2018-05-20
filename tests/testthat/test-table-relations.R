library(tableschema.r)
library(testthat)
library(foreach)
library(rlist)


testthat::context("table-foreign-keys")


SOURCE = '[
["id", "name", "surname"],
["1", "Alex", "Martin"],
["2", "John", "Dockins"],
["3", "Walter", "White"]
]'

SCHEMA = '{
"fields": [
{"name": "id"},
{"name": "name"},
{"name": "surname"}
],
"foreignKeys": [
{
  "fields": "name",
  "reference": {"resource": "people", "fields": "firstname"}
}
]
}'
RELATIONS = '{
"people": [
{"firstname": "Alex", "surname": "Martin"},
{"firstname": "John", "surname": "Dockins"},
{"firstname": "Walter", "surname": "White"}
]
}'

relations = helpers.from.json.to.list(RELATIONS)




test_that("should read rows if single field foreign keys is valid", {
  source = list(
    list('id', 'bad', 'age', 'name', 'occupation'),
    list(1, '10.0', 1, 'string1', '2012-06-15 00:00:00')
  )
  def2  = Table.load(helpers.from.json.to.list(SOURCE), schema = SCHEMA)
  table = future::value(def2)

  rows = table$read(relations = helpers.from.json.to.list(RELATIONS))

  expect_equivalent(rows, list(
    list('1', list(firstname = 'Alex', surname = 'Martin'), 'Martin'),
    list('2', list(firstname = 'John', surname = 'Dockins'), 'Dockins'),
    list('3', list(firstname = 'Walter', surname = 'White'), 'White')

  ))


})


test_that("should throw on read if single field foreign keys is invalid", {
  source = list(
    list('id', 'bad', 'age', 'name', 'occupation'),
    list(1, '10.0', 1, 'string1', '2012-06-15 00:00:00')
  )
  def2  = Table.load(helpers.from.json.to.list(SOURCE), schema = SCHEMA)
  table = future::value(def2)
  relations = helpers.from.json.to.list(RELATIONS)
  relations[["people"]][[3]][["firstname"]] = 'Max'
  expect_error(table$read(relations = relations), ".*Foreign key.*")


})




test_that("should read rows if multi field foreign keys is valid", {

  schema = helpers.from.json.to.list(SCHEMA)
  schema$foreignKeys[[1]]$fields = list('name', 'surname')
  schema$foreignKeys[[1]]$reference$fields = list('firstname', 'surname')

  SCHEMA2 = helpers.from.list.to.json(schema)
  relations = helpers.from.json.to.list(RELATIONS)

  def2  = Table.load(helpers.from.json.to.list(SOURCE), schema = SCHEMA2)
  table = future::value(def2)
  keyedRows = table$read(keyed = TRUE, relations = relations)
  expect_equivalent(keyedRows, list(
    list('1', name = list(firstname = 'Alex', surname = 'Martin'), surname = list(firstname = 'Alex', surname = 'Martin')),
    list('2', name = list(firstname = 'John', surname = 'Dockins'), surname = list(firstname = 'John', surname = 'Dockins')),
    list('3', name = list(firstname = 'Walter', surname = 'White'), surname = list(firstname = 'Walter', surname = 'White'))

  ))
# tar='[
#     {
#       "id": "1",
#       "name": {"firstname": "Alex", "surname": "Martin"},
#       "surname": {"firstname": "Alex", "surname": "Martin"}
#     },
#     {
#       "id": "2",
#       "name": {"firstname": "John", "surname": "Dockins"},
#       "surname": {"firstname": "John", "surname": "Dockins"}
#     },
#     {
#       "id": "3",
#       "name": {"firstname": "Walter", "surname": "White"},
#       "surname": {"firstname": "Walter", "surname": "White"}
#     }
#     ]'
# 
# 
})

test_that("should throw on read if multi field foreign keys is invalid", {

  schema = helpers.from.json.to.list(SCHEMA)
  schema$foreignKeys[[1]]$fields = list('name', 'surname')
  schema$foreignKeys[[1]]$reference$fields = list('firstname', 'surname')

  SCHEMA2 = helpers.from.list.to.json(schema)
  relations = helpers.from.json.to.list(RELATIONS)
  relations$people = rlist::list.remove(relations$people, 3)

  def2  = Table.load(helpers.from.json.to.list(SOURCE), schema = SCHEMA2)
  table = future::value(def2)

  expect_error(table$read(relations = relations), ".*Foreign key.*")


})

