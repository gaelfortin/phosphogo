#' Launch phosphogo app
#' 
#' This function launches the web interface of phosphogo, written with Shiny.
#' @importFrom shiny runApp
#' @export
#' 
#' 
launchApp <- function() {
  appDir <- system.file("shiny-examples", "myapp", package = "phosphogo")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `phosphogo`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}