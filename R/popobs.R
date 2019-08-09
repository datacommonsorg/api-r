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

# Data Commons Node API R Client - Population/Observation Convenience Functions
#
# GetPopulations, GetObservations
#
# These functions provide wrapped access to
# Data Commons Node API Populations convenience functions.
# These functions are designed to making adding a new column
# to a data frame convenient!
#
# www.DataCommons.org

#' Return StatisticalPopulations associated with specified dcids
#'
#' Returns a mapping between the each given Place and the
#'   StatisticalPopulation satisfying all specified constraints
#'   contained in the Place.
#'
#' @param dcids required, dcid(s) identifying Places of populations to query
#'   for. The returned StatisticalPopulations must have location
#'   \url{https://browser.datacommons.org/kg?dcid=location} as one of
#'   these specified dcids.
#'   This parameter will accept a vector of strings, or a single column
#'   tibble/data frame of strings. To select a single column from multicol
#'   tibble/data frame, use \code{select(df, col)}.
#' @param populationType required, string identifying the
#'   population type of the StatisticalPopulation.
#' @param constraintsPVMap required, named list mapping constraining properties
#'   to the desired values that defines the returned StatisticalPopulations
#'   should be constrained by. Example:
#'   \code{list(employment = 'BLS_Employed')}
#' @return dcid strings of populations corresponding to each given Place
#'   satisfying the constraints.
#'   If dcids input is a vector of strings, will be encapsulated in a named
#'   list mapping Place dcids to their unique StatisticalPopulation IF
#'   it has a satisfying population.
#'   If dcids input is a tibble/data frame, will be encapsulated in a new single
#'   column tibble, where the i-th entry corresponds to population located at
#'   the given dcid specified by the population_type and constraining_properties
#'   if such exists. Otherwise, the cell is empty.
#' @export
#' @examples
#' # Set the dcid to be that of Santa Clara County.
#' sccDcid <- 'geoId/06085'
#' # Get the population dcids for Santa Clara County.
#' malePops <- GetPopulations(sccDcid, 'Person', list(gender = 'Male'))
#' femalePops <- GetPopulations(sccDcid, 'Person', list(gender = 'Female'))
#'
#' # Create an atomic vector of the dcids of California, Kentucky and Maryland.
#' stateDcids <- c('geoId/06', 'geoId/21', 'geoId/24')
#' # Get the population dcids for each state.
#' malePops <- GetPopulations(stateDcids, 'Person', list(gender = 'Male'))
#' femalePops <- GetPopulations(stateDcids, 'Person', list(gender = 'Female'))
#'
#' # Create an tibble of the dcids of California, Kentucky, and Maryland.
#' df <- tibble(countyDcid = c('geoId/06', 'geoId/21', 'geoId/24'),
#'              rand = c(1, 2, 3))
#' # Get the population dcids for each state.
#' df$malePops <- GetPopulations(select(df, countyDcid), 'Person',
#'                               list(gender = 'Male'))
#' df$femalePops <- GetPopulations(select(df, countyDcid), 'Person',
#'                                 list(gender = 'Female'))
GetPopulations <- function(dcids, populationType, constraintsPVMap) {
  dcids = ConvertibleToPythonList(dcids)
  return(dc$get_populations(dcids, populationType, constraintsPVMap))
}

#' Return dcids of Observations observing the given dcids
#'
#' Returns a mapping between each given dcid
#'   and the Observations on the specified
#'   property satisfying all specified constraints.
#'
#' @param dcids required, dcid(s) to get observations for. The returned
#'   Observations must have observedNode
#'   \url{https://browser.datacommons.org/kg?dcid=observedNode} as one of
#'   these specified dcids.
#'   This parameter will accept a vector of strings,
#'   or a single column tibble/data frame of strings.
#'   To select a single column from multicol tibble/data frame, use
#'   \code{select(df, col)}.
#' @param measuredProperty required, string identifying the measured property.
#' @param statsType required, string identifying the statistical type of the
#'   measurement.
#' @param observationDate required, string specifying the observation date in
#'   ISO8601 format.
#' @param observationPeriod optional, string specifying the observation period.
#'   E.g. 'P1Y': Period 1 year, 'P2M': Period 2 month, 'P3D': Period 3 day,
#'   'P4m': period 4 minute.
#' @param measurementMethod optional, string specifying a
#'   measurement method.
#' @return Observation values corresponding to each given dcid.
#'   Will be encapsulated in a named list if dcids input is vector of strings
#'   or a new single column tibble if dcids input is tibble/data frame.
#' @export
#' @examples
#' stateDcids <- c('geoId/06', 'geoId/21', 'geoId/24')
#' # Using vectors
#' femalePops <- GetPopulations(stateDcids, 'Person', list(gender = 'Female'))

#' # Atomic vector version
#' # \code{unlist} converts lists to vectors
#' femaleCount <- GetObservations(unlist(femalePops), 'count',
#'                                'measured_value', '2016',
#'                                measurementMethod = 'CenusACS5yrSurvey')
#'
#' # Tibble/data frame version
#' df <- tibble(countyDcid = stateDcids, rand = c(1, 2, 3))
#' df$malePops <- GetPopulations(select(df, countyDcid), 'Person',
#'                               list(gender = 'Male'))
#' df$maleCount <- GetObservations(select(df, malePops), 'count',
#'                                 'measured_value', '2016',
#'                                 measurementMethod = 'CenusACS5yrSurvey')
GetObservations <- function(dcids, measuredProperty, statsType,
                            observationDate, observationPeriod = NULL,
                            measurementMethod = NULL) {
  dcids = ConvertibleToPythonList(dcids)
  return(dc$get_observations(dcids, measuredProperty, statsType,
                             observationDate, observationPeriod,
                             measurementMethod))
}
