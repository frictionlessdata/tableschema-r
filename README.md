Table Schema
================
...

[![Build Status](https://travis-ci.org/okgreece/tableschema-r.svg?branch=master)](https://travis-ci.org/okgreece/tableschema-r) [![Coverage Status](https://coveralls.io/repos/github/okgreece/tableschema-r/badge.svg?branch=master)](https://coveralls.io/github/okgreece/tableschema-r?branch=master) [![Github Issues](http://githubbadges.herokuapp.com/okgreece/tableschema-r/issues.svg)](https://github.com/okgreece/tableschema-r/issues) [![Pending Pull-Requests](http://githubbadges.herokuapp.com/okgreece/tableschema-r/pulls.svg)](https://github.com/okgreece/tableschema-r/pulls) [![Project Status: Inactive – The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](http://www.repostatus.org/badges/latest/inactive.svg)](http://www.repostatus.org/#inactive) [![packageversion](https://img.shields.io/badge/Package%20version-0.0.0.9000-orange.svg?style=flat-square)](commits/master) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.1-6666ff.svg)](https://cran.r-project.org/) [![Licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://opensource.org/licenses/MIT)

tableschema-r
=============

An R library for working with Table Schema.

Features
========

-   **Table** class for working with data and schema
-   **Schema** class for working with schemas
-   **Field** class for working with schema fields
-   **validate** function for validating schema descriptors
-   **infer** function that creates a schema based on a data sample

Getting started
===============

Installation
------------

``` r
install.packages("devtools")
```

``` r
devtools::install_github("okgreece/tableschema-r")
```

Documentation
=============

Table
-----

Schema
------

Field
-----

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

Changelog - News
----------------

Github
======

-   <https://github.com/okgreece/tableschema-r>
