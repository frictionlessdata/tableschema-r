<img src="okgr.png" align="right" width=130px /><img src="oklabs.png" align="right" width=130px /><br><br/><img src="frictionlessdata.png" align="left" width=60 />rictionless Data - <br/> Table Schema
================

[![Build Status](https://travis-ci.org/okgreece/tableschema-r.svg?branch=master)](https://travis-ci.org/okgreece/tableschema-r) [![Coverage Status](https://coveralls.io/repos/github/okgreece/tableschema-r/badge.svg?branch=master)](https://coveralls.io/github/okgreece/tableschema-r?branch=master) [![Github Issues](http://githubbadges.herokuapp.com/okgreece/tableschema-r/issues.svg)](https://github.com/okgreece/tableschema-r/issues) [![Pending Pull-Requests](http://githubbadges.herokuapp.com/okgreece/tableschema-r/pulls.svg)](https://github.com/okgreece/tableschema-r/pulls) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![packageversion](https://img.shields.io/badge/Package%20version-0.0.0.9000-orange.svg?style=flat-square)](commits/master) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.1-6666ff.svg)](https://cran.r-project.org/) [![Licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/frictionlessdata/chat)

Description
===========

R library for working with [Table Schema](http://specs.frictionlessdata.io/table-schema/).

Features
========

-   `Table` class for working with data and schema
-   `Schema` class for working with schemas
-   `Field` class for working with schema fields
-   `validate` function for validating schema descriptors
-   `infer` function that creates a schema based on a data sample

Getting started
===============

Installation
------------

In order to install the latest distribution of [R software](https://www.r-project.org/) to your computer you have to select one of the mirror sites of the [Comprehensive R Archive Network](https://cloud.r-project.org/), select the appropriate link for your operating system and follow the wizard instructions.

For windows users you can:

1.  Go to CRAN
2.  Click download R for Windows
3.  Click Base (This is what you want to install R for the first time)
4.  Download the latest R version
5.  Run installation file and follow the instrustions of the installer.

(Mac) OS X and Linux users may need to follow different steps depending on their system version to install R successfully and it is recommended to read the instructions on CRAN site carefully.

Even more detailed installation instructions can be found in [R Installation and Administration manual](https://cran.r-project.org/doc/manuals/R-admin.html).

To install [RStudio](https://www.rstudio.com/), you can download [RStudio Desktop](https://www.rstudio.com/products/rstudio/download/) with Open Source License and follow the wizard instructions:

1.  Go to [RStudio](https://www.rstudio.com/products/rstudio/)
2.  Click download on RStudio Desktop
3.  Download on RStudio Desktop free download
4.  Select the appropriate file for your system
5.  Run installation file

To install the `tableschema` library it is necessary to install first `devtools` library to make installation of github libraries available.

``` r
# Install devtools package if not already
install.packages("devtools")
```

Install `tableschema.r`

``` r
# And then install the development version from github
devtools::install_github("okgreece/tableschema-r")
```

Load library
------------

``` r
# load the library using
library(tableschema.r)
```

Documentation
=============

The package is still under development and some properties may not be working properly.

Table
-----

A table is a core concept in a tabular data world. It represents a data with a metadata (Table Schema). Let's see how we could use it in practice.

Consider we have some local csv file. It could be inline data or remote link - all supported by `Table` class (except local files for in-brower usage of course). But say it's `data.csv` for now:

> data/cities.csv

``` csv
city,location
london,"51.50,-0.11"
paris,"48.85,2.30"
rome,N/A
```

Let's create and read a table. We use static `Table.load` method and `table.read` method with a `keyed` option to get array of keyed rows:

``` r
table = Table.load('data.csv')
table$headers # ['city', 'location']
table$read(keyed = TRUE)
# [
#   {city: 'london', location: '51.50,-0.11'},
#   {city: 'paris', location: '48.85,2.30'},
#   {city: 'rome', location: 'N/A'},
# ]
```

As we could see our locations are just a strings. But it should be geopoints. Also Rome's location is not available but it's also just a `N/A` string instead of JavaScript `null`. First we have to infer Table Schema:

``` r
table$infer()
table$schema$descriptor
# { fields:
#   [ { name: 'city', type: 'string', format: 'default' },
#     { name: 'location', type: 'geopoint', format: 'default' } ],
#  missingValues: [ '' ] }
table.read(keyed = TRUE)
# Fails with a data validation error
```

Let's fix not available location. There is a `missingValues` property in Table Schema specification. As a first try we set `missingValues` to `N/A` in `table.schema.descriptor`. Schema descriptor could be changed in-place but all changes sould be commited by `table.schema.commit()`:

``` r
table$schema$descriptor['missingValues'] = 'N/A'
table$schema$commit()
table$schema$valid # false
table$schema$errors
# Error: Descriptor validation error:
#   Invalid type: string (expected array)
#    at "/missingValues" in descriptor and
#    at "/properties/missingValues/type" in profile
```

As a good citiziens we've decided to check out schema descriptor validity. And it's not valid! We sould use an array for `missingValues` property. Also don't forget to have an empty string as a missing value:

``` r
table$schema$descriptor['missingValues'] = list('', 'N/A')
table$schema$commit()
table$schema$valid # true
```

All good. It looks like we're ready to read our data again:

``` r
table$read(keyed = TRUE)
# [
#   {city: 'london', location: [51.50,-0.11]},
#   {city: 'paris', location: [48.85,2.30]},
#   {city: 'rome', location: null},
# ]
```

Now we see that: - locations are arrays with numeric lattide and longitude - Rome's location is a native JavaScript `null`

And because there are no errors on data reading we could be sure that our data is valid againt our schema. Let's save it:

``` r
table$schema$save('schema.json')
table$save('data.csv')
```

Our `data.csv` looks the same because it has been stringified back to `csv` format. But now we have `schema.json`:

``` json
{
    "fields": [
        {
            "name": "city",
            "type": "string",
            "format": "default"
        },
        {
            "name": "location",
            "type": "geopoint",
            "format": "default"
        }
    ],
    "missingValues": [
        "",
        "N/A"
    ]
}
```

If we decide to improve it even more we could update the schema file and then open it again. But now providing a schema path and iterating thru the data using Node Streams:

``` r
table = Table.load('data.csv', schema = 'schema.json')
stream = table$iter(stream = TRUE)
stream.on('data', (row) => {
  # handle row ['london', [51.50,-0.11]] etc
  # keyed/extended/cast supported in a stream mode too
})
```

It was onle basic introduction to the `Table` class. To learn more let's take a look on `Table` class API reference.

Schema
------

Field
-----

Class represents field in the schema.

Data values can be cast to native R types. Casting a value will check the value is of the expected type, is in the correct format, and complies with any constraints imposed by a schema.

``` r
{
    'name': 'birthday',
    'type': 'date',
    'format': 'default',
    'constraints': {
        'required': True,
        'minimum': '2015-05-30'
    }
}
```

Following code will not raise the exception, despite the fact our date is less than minimum constraints in the field, because we do not check constraints of the field descriptor

``` r
dateType = types.castDate(value = '2014-05-29') # cast date
dateType # print the result
```

Values that can't be cast will raise an Error exception. Casting a value that doesn't meet the constraints will raise an Error exception.

Table below shows the available types, formats and resultant value of the cast:

<table style="width:85%;">
<colgroup>
<col width="16%" />
<col width="41%" />
<col width="26%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Type</th>
<th align="left">Formats</th>
<th align="left">Casting result</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>any</p></td>
<td align="left"><p>default</p></td>
<td align="left"><p>Any</p></td>
</tr>
<tr class="even">
<td align="left"><p>array</p></td>
<td align="left"><p>default</p></td>
<td align="left"><p>Array</p></td>
</tr>
<tr class="odd">
<td align="left"><p>boolean</p></td>
<td align="left"><p>default</p></td>
<td align="left"><p>Boolean</p></td>
</tr>
<tr class="even">
<td align="left"><p>date</p></td>
<td align="left"><p>default, any</p></td>
<td align="left"><p>Date</p></td>
</tr>
<tr class="odd">
<td align="left"><p>datetime</p></td>
<td align="left"><p>default, any</p></td>
<td align="left"><p>Date</p></td>
</tr>
<tr class="even">
<td align="left"><p>duration</p></td>
<td align="left"><p>default</p></td>
<td align="left"><p>Duration</p></td>
</tr>
<tr class="odd">
<td align="left"><p>geojson</p></td>
<td align="left"><p>default, topojson</p></td>
<td align="left"><p>Object</p></td>
</tr>
<tr class="even">
<td align="left"><p>geopoint</p></td>
<td align="left"><p>default, array, object</p></td>
<td align="left"><p>[Number, Number]</p></td>
</tr>
<tr class="odd">
<td align="left"><p>integer</p></td>
<td align="left"><p>default</p></td>
<td align="left"><p>Number</p></td>
</tr>
<tr class="even">
<td align="left"><p>number</p></td>
<td align="left"><p>default</p></td>
<td align="left"><p>Number</p></td>
</tr>
<tr class="odd">
<td align="left"><p>object</p></td>
<td align="left"><p>default</p></td>
<td align="left"><p>Object</p></td>
</tr>
<tr class="even">
<td align="left"><p>string</p></td>
<td align="left"><p>default, uri, email, binary</p></td>
<td align="left"><p>String</p></td>
</tr>
<tr class="odd">
<td align="left"><p>time</p></td>
<td align="left"><p>default, any</p></td>
<td align="left"><p>Date</p></td>
</tr>
<tr class="even">
<td align="left"><p>year</p></td>
<td align="left"><p>default</p></td>
<td align="left"><p>Number</p></td>
</tr>
<tr class="odd">
<td align="left"><p>yearmonth</p></td>
<td align="left"><p>default</p></td>
<td align="left"><p>[Number, Number]</p></td>
</tr>
</tbody>
</table>

### Validate - `is.valid()`

> `is.valid()` validates whether a **schema** is a validate Table Schema accordingly to the [specifications](http://schemas.datapackages.org/json-table-schema.json). It does **not** validate data against any other schema.

Changelog - News
----------------

In [NEWS.md](https://github.com/okgreece/tableschema-r/blob/master/NEWS.md) described only breaking and the most important changes. The full changelog could be found in nicely formatted [commit](https://github.com/okgreece/tableschema-r/commits/master) history.

Contributing
============

The project follows the [Open Knowledge International coding standards](https://github.com/okfn/coding-standards). There are common commands to work with the project.Recommended way to get started is to create, activate and load the library environment. To install package and development dependencies into active environment:

``` r
devtools::install_github("okgreece/tableschema-r",dependencies=TRUE)
```

To make test:

``` r
  test_that(description, {
    expect_equal(test, expected result)
  })
```

To run tests:

``` r
devtools::test()
```

    ## Loading tableschema.r

    ## Loading required package: testthat

    ## Testing tableschema.r

    ## constraints.checkEnum: ...
    ## constraints.checkMaximum: ...
    ## constraints.checkMaxLength: ...
    ## constraints.checkMinimum: ...
    ## constraints.checkMinLength: ...
    ## constraints.checkPattern: ..
    ## constraints.checkRequired: ....
    ## constraints.checkUnique: ..
    ## Fields: ..................

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

    ## profile: 
    ## types.castAny: .....
    ## types.castBoolean: ..........................
    ## types.castDate: .........................
    ## types.castDatetime: .......................
    ## types.castGeojson: ...........
    ## types.castGeopoint: .............................
    ## types.castInteger: ......
    ## types.castNumber: ................................
    ## types.castString: ...............
    ## types.castYear: ......
    ## types.castYearmonth: ...........
    ## 
    ## DONE ======================================================================

more detailed information about how to create and run tests you can find in [testthat package](https://github.com/hadley/testthat)

Github
======

-   <https://github.com/okgreece/tableschema-r>

<img src="okgr.png" align="right" width=120px /><img src="oklabs.png" align="right" width=120px />
