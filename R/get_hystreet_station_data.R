#' Get data from a specific location from the Hystreet Project via Hystreet API
#'
#' @param hystreetId [integer] (**required**): ID of the requested statin. See [get_hystreet_locations()] for an overview of 
#' available IDs.
#' @param query [list] (**optional**): A list with queries. Up do date the following queries are supported:
#' * from: datetime of earliest measurement (default: today 00:00:00:): e.g. "2018-10-01 12:00:00" or "2018-10-01"
#' * to : datetime of latest measurement (default: today 23:59:59): e.g. "2018-01-12 12:00:00" or "2018-12-01"
#' * resoution: Resultion for the measurement grouping (default: hour): "day", "hour", "month", "week"
#' @param API_token [character] (**optional**): API key to get access to Hystreet API
#' 
#' @return [data.frame] with parsed data from hystreet API
#'
#' @section Function version 0.0.1
#' @author Johannes Friedrich
#' 
#' @examples 
#' \dontrun{
#' ## request data of the current day of station with hystreetId 71
#' data <- get_hystreet_station_data(71)
#' 
#' ## request data of December 2018 with resolution "day"
#' data <- get_hystreet_station_data(
#'    hystreetId = 71, 
#'    query = list(from = "2018-12-01", to = "2018-12-31", resolution = "day"))
#' ## is the same as 
#' ## get_hystreet_station_data(
#' ##   hystreetId = 71, 
#' ##   query = list(from = "2018-12-01", to = "2018-12-31", resolution = "day"))
#'  }
#' @md
#' @export

get_hystreet_station_data <- function(
  hystreetId = NULL, 
  query = NULL,
  API_token = NULL){
  
  ##=======================================##
  ## ERROR HANDLING
  ##=======================================##
  
  if (is.null(hystreetId))
    stop("[get_hystreet_station_data()] Argument 'hystreetId' has to be set.", call. = FALSE)
  
  if (!is.null(query) && class(query) != "list")
    stop("[get_hystreet_station_data()] Argument 'query' has to be a list", call. = FALSE)
  
  # Ids_loop <- lapply(1:length(hystreetId), function(Id){
  
  
  res <- .create_hystreet_request(API_token, 
                                  hystreetId = hystreetId, 
                                  query = query)
  
  res$measurements$timestamp <- .convert_dates(res$measurements$timestamp)
  res$metadata$earliest_measurement_at <- .convert_dates(res$metadata$earliest_measurement_at)
  res$metadata$latest_measurement_at <- .convert_dates(res$metadata$latest_measurement_at)
  
  return(res)
  
  # })
  # 
  # names(Ids_loop) <- hystreetId
  # 
  # return(Ids_loop)
  
}