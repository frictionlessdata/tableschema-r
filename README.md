Table Schema
================
...

[![Build Status](https://travis-ci.org/okgreece/tableschema-r.svg?branch=master)](https://travis-ci.org/okgreece/tableschema-r) [![Coverage Status](https://coveralls.io/repos/github/okgreece/tableschema-r/badge.svg?branch=master)](https://coveralls.io/github/okgreece/tableschema-r?branch=master) [![Github Issues](http://githubbadges.herokuapp.com/okgreece/tableschema-r/issues.svg)](https://github.com/okgreece/tableschema-r/issues) [![Pending Pull-Requests](http://githubbadges.herokuapp.com/okgreece/tableschema-r/pulls.svg)](https://github.com/okgreece/tableschema-r/pulls) [![Project Status: Inactive – The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](http://www.repostatus.org/badges/latest/inactive.svg)](http://www.repostatus.org/#inactive) [![packageversion](https://img.shields.io/badge/Package%20version-0.0.0.9000-orange.svg?style=flat-square)](commits/master) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.1-6666ff.svg)](https://cran.r-project.org/) [![Licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://opensource.org/licenses/MIT)

tableschema-r
=============

An R library for working with Data Package.

Table below shows the available types, formats and resultant value of the cast:

<table style="width:85%;">
<colgroup>
<col width="16%" />
<col width="41%" />
<col width="26%" />
</colgroup>
<thead>
<tr class="header">
<th>Type</th>
<th>Formats</th>
<th>Casting result</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>any</p></td>
<td><p>default</p></td>
<td><p>Any</p></td>
</tr>
<tr class="even">
<td><p>array</p></td>
<td><p>default</p></td>
<td><p>Array</p></td>
</tr>
<tr class="odd">
<td><p>boolean</p></td>
<td><p>default</p></td>
<td><p>Boolean</p></td>
</tr>
<tr class="even">
<td><p>date</p></td>
<td><p>default, any</p></td>
<td><p>Date</p></td>
</tr>
<tr class="odd">
<td><p>datetime</p></td>
<td><p>default, any</p></td>
<td><p>Date</p></td>
</tr>
<tr class="even">
<td><p>duration</p></td>
<td><p>default</p></td>
<td><p>Duration</p></td>
</tr>
<tr class="odd">
<td><p>geojson</p></td>
<td><p>default, topojson</p></td>
<td><p>Object</p></td>
</tr>
<tr class="even">
<td><p>geopoint</p></td>
<td><p>default, array, object</p></td>
<td><p>[Number, Number]</p></td>
</tr>
<tr class="odd">
<td><p>integer</p></td>
<td><p>default</p></td>
<td><p>Number</p></td>
</tr>
<tr class="even">
<td><p>number</p></td>
<td><p>default</p></td>
<td><p>Number</p></td>
</tr>
<tr class="odd">
<td><p>object</p></td>
<td><p>default</p></td>
<td><p>Object</p></td>
</tr>
<tr class="even">
<td><p>string</p></td>
<td><p>default, uri, email, binary</p></td>
<td><p>String</p></td>
</tr>
<tr class="odd">
<td><p>time</p></td>
<td><p>default, any</p></td>
<td><p>Date</p></td>
</tr>
<tr class="even">
<td><p>year</p></td>
<td><p>default</p></td>
<td><p>Number</p></td>
</tr>
<tr class="odd">
<td><p>yearmonth</p></td>
<td><p>default</p></td>
<td><p>[Number, Number]</p></td>
</tr>
</tbody>
</table>
