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
# get_populations, get_observations
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
#' @param population_type required, string identifying the
#'   population type of the StatisticalPopulation.
#' @param constraining_properties optional, named list mapping constraining property to
#'   the value that the StatisticalPopulation should be constrained by. Empty by
#'   default. Example: \code{list(employment = 'BLS_Employed')}
#' @return If dcids input is a vector of strings, returns a named
#'   list mapping a given dcid to the unique StatisticalPopulation
#'   located at the dcid as specified by the population_type and
#'   constrainingProperties, if such a StatisticalPopulation exists.
#'   A given dcid will NOT be a member of the dict if such a
#'   StatisticalPopulation does not exist.
#'
#'   If dcids input is a tibble/data frame, returns a new single column
#'   tibble, where the i-th entry corresponds to the StatisticalPopulation
#'   located at the given dcid specified by the population_type and
#'   constrainingProperties, if such exists. Otherwise, the cell is empty.
#' @export
#' @examples
#' # Set the dcid to be that of Santa Clara County.
#' sccDcid <- 'geoId/06085'
#' # Get the population dcids for Santa Clara County.
#' malePops <- get_populations(sccDcid, 'Person', list(gender = 'Male'))
#' femalePops <- get_populations(sccDcid, 'Person', list(gender = 'Female'))
#'
#' # Create an atomic vector of the dcids of California, Kentucky and Maryland.
#' stateDcids <- c('geoId/06', 'geoId/21', 'geoId/24')
#' # Get the population dcids for each state.
#' malePops <- get_populations(stateDcids, 'Person', list(gender = 'Male'))
#' femalePops <- get_populations(stateDcids, 'Person', list(gender = 'Female'))
#'
#' # Create an tibble of the dcids of California, Kentucky, and Maryland.
#' df <- tibble(countyDcid = c('geoId/06', 'geoId/21', 'geoId/24'),
#'              rand = c(1, 2, 3))
#' # Get the population dcids for each state.
#' df$malePops <- get_populations(select(df, countyDcid), 'Person',
#'                               list(gender = 'Male'))
#' df$femalePops <- get_populations(select(df, countyDcid), 'Person',
#'                                 list(gender = 'Female'))
get_populations <- function(dcids, population_type, constraining_properties = NULL) {
  dcids = convertible_to_python(dcids)
  if (is.null(constraining_properties)) {
    return(call_python(dc$get_populations, list(dcids, population_type)))
  } else {
    return(call_python(dc$get_populations, list(dcids, population_type, constraining_properties)))
  }
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
#' @param measured_property required, string identifying the measured property.
#' @param stats_type required, string identifying the statistical type of the
#'   measurement.
#' @param observation_date required, string specifying the observation date in
#'   ISO8601 format.
#' @param observation_period optional, string specifying the observation period.
#'   E.g. 'P1Y': Period 1 year, 'P2M': Period 2 month, 'P3D': Period 3 day,
#'   'P4m': period 4 minute.
#' @param measurement_method optional, string specifying a
#'   measurement method.
#' @return Observation values corresponding to each given dcid.
#'   Will be encapsulated in a named list if dcids input is vector of strings
#'   or a new single column tibble if dcids input is tibble/data frame.
#'
#'   If dcids input is a vector of strings, returns a named
#'   list mapping a given dcid to the unique Observation
#'   observing the dcid, where the observation is specified by what is given
#'   in the other parameters.
#'   A given dcid will NOT be a member of the dict if such an observation
#'   does not exist.
#'
#'   If dcids input is a tibble/data frame, returns a new single column
#'   tibble, where the i-th entry corresponds to the Observation
#'   observing the given dcid as specified by the other parameters, if
#'   such exists. Otherwise, the cell is empty.
#' @export
#' @examples
#' stateDcids <- c('geoId/06', 'geoId/21', 'geoId/24')
#' # Using vectors
#' femalePops <- get_populations(stateDcids, 'Person', list(gender = 'Female'))

#' # Atomic vector version
#' # \code{unlist} converts lists to vectors
#' femaleCount <- get_observations(unlist(femalePops), 'count',
#'                                'measured_value', '2016',
#'                                measurement_method = 'CensusACS5yrSurvey')
#'
#' # Tibble/data frame version
#' df <- tibble(countyDcid = stateDcids, rand = c(1, 2, 3))
#' df$malePops <- get_populations(select(df, countyDcid), 'Person',
#'                               list(gender = 'Male'))
#' df$maleCount <- get_observations(select(df, malePops), 'count',
#'                                 'measured_value', '2016',
#'                                 measurement_method = 'CensusACS5yrSurvey')
get_observations <- function(dcids, measured_property, stats_type,
                            observation_date, observation_period = NULL,
                            measurement_method = NULL) {
  dcids = convertible_to_python(dcids)
  return(call_python(dc$get_observations, list(dcids, measured_property, stats_type,
                             observation_date, observation_period,
                             measurement_method)))
}
