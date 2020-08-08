#' NetworKIN setup
#' NetworKIN is properly setup with this function.
#' @export
#' 
networkin_setup <- function(){
  message('Unzipping NetworKIN archive...')
  unzip('networkin.zip')
  system("chmod +x networkin/bin/NetworKIN3.0_release/NetworKIN.py") # Allow NetworKIN to be executed
  message('NetworKIN setup completed.')
}