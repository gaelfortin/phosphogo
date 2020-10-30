#' Launch phosphogo app
#' 
#' This function launches the web interface of phosphogo, written with Shiny.
#' @importFrom shiny runApp
#' @export
#' 

launchApp <- function(){
  runApp('gui')
}