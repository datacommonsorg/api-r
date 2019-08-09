## Pre-release R API Client
This is a beta library. Support is scheduled to stop on Sept 30.
The official release is coming soon.

The R API Client facilitates querying the DataCommons.org
Open Knowledge Graph from R.

It supports querying the graph via SPARQL
queries to the Data Commons REST API endpoint:

```
# Populate a data frame with columns specified with SPARQL
queryString = "SELECT ?pop ?Unemployment
    WHERE {
     ?pop typeOf StatisticalPopulation .
     ?o typeOf Observation .
     ?pop dcid ('dc/p/qep2q2lcc3rcc' 'dc/p/gmw3cn8tmsnth' 'dc/p/92cxc027krdcd') .
     ?o observedNode ?pop .
     ?o measuredValue ?Unemployment
   }"
df = Query(queryString)
```

Along with function calls to the Data Commons Node API endpoint, such as:
```
# DCID string of Santa Clara County
sccDcid <- 'geoId/06085'
# Get incoming properties of Santa Clara County
inLabels <- GetPropertyLabels(sccDcid, outgoing = FALSE)
```

WiFi is needed for all functions in this package.

### To use this R API Client to access Data Commons REST API

In the R console, run:

```
if(!require(devtools)) install.packages("devtools")
library(devtools)
devtools::install_github("datacommonsorg/api-r")
library(datacommons)
SetApiKey(YOUR-API-KEY)
```

### Summary of Functions

For more detail, use `help(function)` in the R console, or the shortcut `?function`.

- Query: build R dataframes using data via SPARQL queries to the Query API.
- GetTriples: get all triples (subject-predicate-object) where the specified node is
  either a subject or an object.
- GetPropertyValues: get values neighboring each specified node via the specified
  property and direction.
- GetPropertyLabels: get property labels of each specified node.
- GetPlacesIn: get places of a specified type contained in each specified place.
- GetPopulations: get populations of each specified place.
- GetObservations: get observations on the specified property of each node.

### To develop on this R API Client

#### Clone the Repo

[Data Commons Github Repo](https://github.com/datacommonsorg/api-r)

[GitHub Cloning Docs](https://help.github.com/en/articles/cloning-a-repository)

#### Load the devtools library
```
if(!require(devtools)) install.packages("devtools")
library(devtools)
```

#### To load/reload the code
Keyboard shortcut: `Cmd/Ctrl + Shift + L`

Or in R console, run:
```
# Make sure you're inside the R API Client directory
devtools::load_all()
SetApiKey(YOUR-API-KEY)
```

#### To generate/regenerate the docs
Keyboard shortcut: `Cmd/Ctrl + Shift + D` (if this doesn't work, go to
`Tools > Project Options > Build Tools`
and check `Generate documentation with Roxygen`)

Or in R console, run:
```
# Make sure you're inside the R API Client directory
devtools::document()
```

These commands trigger the roxygen2 package to regenerate the docs based on
any changes to the docstrings in the R/ folder. Here is an
[introduction](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html)
to using roxygen2.

#### To run tests
Keyboard shortcut: `Cmd/Ctrl + Shift + T`

Or in R console, run:
```
# Make sure you're inside the R API Client directory
devtools::test()
```

#### Working with Reticulate

In `zzz.R`, the Python Client dependency is installed via pip. On many systems,
this would default to install the Python Client to Python2. You can use pip3 to
install the Python Client in Python3. If you do so, in the R console:
```
# Reassign datacommons import without loading (allows you to set python first)
dc <<- reticulate::import("datacommons", delay_load = TRUE)
# Modify and run the next line:
use_python("/usr/local/bin/python3.7")
```
Reticulate also supports the usage of virtual environments. Learn more at https://rstudio.github.io/reticulate/articles/versions.html
