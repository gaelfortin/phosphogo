#' NetworKIN setup
#' NetworKIN is properly downloaded and installed with this function.
#' @importFrom utils unzip
#' @export
#' 
networkin_setup <- function(){
  message('Downloading NetworKIN archive...')
  download.file('https://drive.google.com/uc?export=download&confirm=mnFh&id=1ALZNg_k1iGpYMW6Gp40oFIhkKRGGlOHu', 'networkin.zip')
  message('Unzipping NetworKIN archive...')
  unzip(networkin.zip)
  system(paste0("chmod +x ", networkin_folder, "/bin/NetworKIN3.0_release/NetworKIN.py")) # Allow NetworKIN to be executed
  message('NetworKIN setup completed.')
}
