#' NetworKIN human predictions database
#' 
#' This database is used to generate predictions for a given list of phosphosites.
#' This database was generated in November 2020 against all phosphosites registered
#' on PhosphoSitePlus. Predictions with a NetworKIN score below 0.1 were excluded.
#' @docType data
#' @usage data("predictions_networkin_nov2020")
#' @format An object of class \code{"data.frame"}
#' @keywords dataset
#' @examples 
#' data("predictions_networkin_nov2020") 
#' head(predictions_networkin_nov2020)
"predictions_networkin_nov2020"
