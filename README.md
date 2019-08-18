# Pre-release Data Commons R API Client
Thank you for your interest in the Data Commons R API Client. This library is currently in beta mode. We will release and switch support to an official release soon.

This R API Client facilitates querying the [DataCommons.org](https://datacommons.org)
Open Knowledge Graph from R.

Querying the graph via [SPARQL](https://en.wikipedia.org/wiki/SPARQL)
queries to the Data Commons REST API endpoint go through the `Query` function. For example:

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

Calls to the Data Commons Node API endpoint are facilitated by functions:

- GetTriples: get all triples (subject-predicate-object) where the specified node is
  either a subject or an object.
  
- GetPropertyValues: get values neighboring each specified node via the specified
  property and direction.
  
- GetPropertyLabels: get property labels of each specified node.

- GetPlacesIn: get places of a specified type contained in each specified place.

- GetPopulations: get populations of each specified place.

- GetObservations: get observations on the specified property of each node.

For example:
```
# DCID string of Santa Clara County
sccDcid <- 'geoId/06085'
# Get incoming properties of Santa Clara County
inLabels <- GetPropertyLabels(sccDcid, outgoing = FALSE)
```

WiFi is needed for all functions in this package. For more detail on usage of any of these functions, use `help(function)` in the R console, or the shortcut `?function`.


## User Quickstart

### Getting an API Key
Using the Data Commons API requires you to provision an API key on GCP. Follow 
[these steps](https://datacommons.readthedocs.io/en/latest/started.html#creating-an-api-key)
to create your own key.

### Installing

#### Downloading the Pre-Built (tar.gz) Library

If you received a tar.gz file from us,

1. Go to the R console to install the CRAN dependencies:
```
install.packages(c("tidyverse", "httr", "jsonlite", "reticulate"))
```

2. Go to the command line to install the Data Commons API R Client via the tar.gz file:

```
R CMD INSTALL <the tar.gz file>
```

3. Return to the R console to load in the client and set the API key so you can get started:
```
library(datacommons)
SetApiKey(YOUR-API-KEY)
```

#### Using the R devtools Library

The devtools library requires some development tools (for Windows: Rtools, for Mac: Xcode command line tools, for Linux: R development package). If you have not already installed them, follow [the devtools guide](https://www.rstudio.com/products/rpackages/devtools/).

Go to the R console and run:

```
if(!require(devtools)) install.packages("devtools")
library(devtools)
devtools::install_github("datacommonsorg/api-r")
library(datacommons)
SetApiKey(YOUR-API-KEY)
```

#### Cloning and Building from GitHub

From the Terminal, run:

```
git clone https://github.com/datacommonsorg/api-r.git
```

The devtools library requires some development tools (for Windows: Rtools, for Mac: Xcode command line tools, for Linux: R development package). If you have not already installed them, follow [the devtools guide](https://www.rstudio.com/products/rpackages/devtools/).

Then, open up RStudio and create a new project using the cloned api-r directory.
In the R console, run:

```
if(!require(devtools)) install.packages("devtools")
library(devtools)
# Make sure you're inside the R API Client directory
devtools::load_all()
SetApiKey(YOUR-API-KEY)
```

#### Tutorial
**We recommend starting with the [Demo Notebook](demo-notebook.Rmd) for an
introduction to Data Commons graph, vocabulary, and data model.**
If you did not clone this repo, feel free to download the
[raw Rmd file](https://raw.githubusercontent.com/datacommonsorg/api-r/master/demo-notebook.Rmd) and paste it into a new R Markdown file. If you did clone the repo, simply open up the file and run the chunks or knit the file.

## To develop on this R API Client {#dev-install}

### Clone the Repo

[Data Commons Github Repo](https://github.com/datacommonsorg/api-r)

[GitHub Cloning Docs](https://help.github.com/en/articles/cloning-a-repository)

### Load the devtools library
```
if(!require(devtools)) install.packages("devtools")
library(devtools)
```

### To load/reload the code
Keyboard shortcut: `Cmd/Ctrl + Shift + L`

Or in R console, run:
```
# Make sure you're inside the R API Client directory
devtools::load_all()
SetApiKey(YOUR-API-KEY)
```

### To generate/regenerate the docs
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

### To run tests
1. Make sure you've set your API Key with `SetApiKey("YOUR_API_KEY")`.

2. Run the test suite:

With keyboard shortcut: `Cmd/Ctrl + Shift + T`

Or in R console, run:
```
# Make sure you're inside the R API Client directory
devtools::test()
```

### To build the library export tar.gz

In the command line, run

```
R CMD BUILD api-R
```

### Working with Reticulate

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
