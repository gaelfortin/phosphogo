#' NetworKIN setup
#' 
#' NetworKIN is properly downloaded and installed with this function.
#' @importFrom utils unzip
#' @export
#' 
networkin_setup <- function(){
  message('Downloading NetworKIN archive...')
  download.file('https://onedrive.live.com/download?cid=38F5374142AA4416&resid=38F5374142AA4416%213567&authkey=AGdpgSa0BgvVV-U', 'networkin.zip')
  message('Unzipping NetworKIN archive...')
  system('unzip networkin.zip') #use unix unzip as R unzip alters networkin files
  system(paste0("chmod +x networkin/bin/NetworKIN3.0_release/NetworKIN.py")) # Allow NetworKIN to be executed
  message('NetworKIN setup completed.')
}
