# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Data Commons Node API - Core Functions
#
# These functions provide R access to core
#   Data Commons Node API functions:
#   get_property_labels, get_property_values, get_triples.
#   www.DataCommons.org


#' Return property labels of specified nodes
#'
#' Returns a map between nodes and outgoing (default) or incoming
#'   property labels.
#'
#' @param dcids required, vector of string(s) of dcid(s) to get
#'   property labels for.
#' @param outgoing optional, boolean flag indicating whether to get properties
#'   that point away from the given node(s). TRUE by default.
#' @return Named list mapping dcids to lists of property labels via the
#'   given direction.
#' @export
#' @examples
#' # dcid string of Santa Clara County.
#' sccDcid <- 'geoId/06085'
#' # Get incoming and outgoing properties for Santa Clara County.
#' inLabels <- GetPropertyLabels(sccDcid, outgoing = FALSE)
#' outLabels <- GetPropertyLabels(sccDcid)
#'
#' # List of dcid strings of Florida, Planned Parenthood West, and the
#' # Republican Party.
#' dcids <- c('geoId/12', 'plannedParenthood-PlannedParenthoodWest',
#'            'politicalParty/RepublicanParty')
#' # Get incoming and outgoing properties for Santa Clara County.
#' inLabels <- GetPropertyLabels(dcids, outgoing = FALSE)
#' outLabels <- GetPropertyLabels(dcids)
GetPropertyLabels <- function(dcids, outgoing = TRUE) {
  dcids = ConvertibleToPythonList(dcids)
  return(dc$get_property_labels(dcids, outgoing))
}

#' Return property values along a property for one or more nodes
#'
#' Returns all neighboring nodes of each specified node via the specified
#'   property and direction. The neighboring nodes are "values" for the
#'   property and can be leaf (primitive) nodes.
#'
#' @param dcids required, vector OR single-column tibble/data frame of
#'   string(s) of dcid(s) to get property values for.
#' @param prop required, string identifying the property to get the property
#'   values for.
#' @param outgoing optional, boolean flag indicating whether the property
#'   is directed away from the given nodes. TRUE by default.
#' @param valueType optional, string identifying the node type to filter the
#'    returned property values by. NULL by default.
#' @param limit optional, integer indicating the maximum number of property
#'   values returned aggregated over all given nodes. 100 by default.
#' @return Named list or column of property values associated to given dcid(s)
#'   via the given property and direction.
#'   Will be encapsulated in a named list if dcids input is vector of strings,
#'   or a new single column tibble if dcids input is tibble/data frame.
#' @export
#' @examples
#' # Set the dcid to be that of Santa Clara County.
#' sccDcid <- 'geoId/06085'
#' # Get the landArea value of Santa Clara (a leaf node).
#' landArea <- GetPropertyValues(sccDcid, 'landArea')
#'
#' # Create a vector with Santa Clara and Miami-Dade County dcids
#' countyDcids <- c('geoId/06085', 'geoId/12086')
#' # Get all containing Cities.
#' cities <- GetPropertyValues(countyDcids, 'containedInPlace',
#'                             outgoing = FALSE, valueType = 'City')
#'
#'# Create a data frame with Santa Clara and Miami-Dade County dcids
#' df <- data.frame(countyDcid = c('geoId/06085', 'geoId/12086'))
#' # Get all containing Cities.
#' df$cityDcid <- GetPropertyValues(select(df, countyDcid), 'containedInPlace',
#'                                  outgoing = FALSE, valueType = 'City')
GetPropertyValues <- function(dcids, prop, outgoing = TRUE, valueType = NULL,
                              limit = 100) {
  dcids = ConvertibleToPythonList(dcids)
  return(dc$get_property_values(dcids, prop, outgoing, valueType, limit))
}

#' Return all triples involving specified nodes
#'
#' Returns all triples (subject-predicate-object) where the specified node is
#' either a subject or an object.
#'
#' @param dcids required, vector of string(s) of dcids to get triples for.
#' @param limit optional, integer indicating the max number of triples to
#'   return. 100 by default.
#' @return Map between each dcid and a list of all triples where the dcid is
#'   the subject or object.
#' @export
#' @examples
#' # Set the dcid to be that of Santa Clara County.
#' sccDcid <- 'geoId/06085'
#' # Get triples.
#' triples <- GetTriples(sccDcid)
#'
#' # List of dcid strings of Florida, Planned Parenthood West, and the
#' # Republican Party.
#' dcids <- c('geoId/12', 'plannedParenthood-PlannedParenthoodWest',
#'            'politicalParty/RepublicanParty')
#' # Get triples.
#' triples <- GetPropertyLabels(dcids)
GetTriples <- function(dcids, limit = 100) {
  dcids = ConvertibleToPythonList(dcids)
  return(dc$get_triples(dcids, limit))
}
