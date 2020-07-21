#' NetworKIN setup
#' NetworKIN is properly setup with this function.
#' @export
#' 
networkin_setup <- function(){
  message('Unzipping NetworKIN archive...')
  unzip('networkin.zip')
  message('NetworKIN setup completed.')
}