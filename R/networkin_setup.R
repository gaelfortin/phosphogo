#' NetworKIN setup
#' NetworKIN is properly downloaded and installed with this function.
#' @importFrom utils unzip
#' @export
#' 
networkin_setup <- function(){
  message('Downloading NetworKIN archive...')
  download.file('https://github.com/gaelfortin/phosphogo/raw/master/networkin.zip', 'networkin.zip')
  message('Unzipping NetworKIN archive...')
  unzip(networkin_zip)
  system(paste0("chmod +x ", networkin_folder, "/bin/NetworKIN3.0_release/NetworKIN.py")) # Allow NetworKIN to be executed
  message('NetworKIN setup completed.')
}
