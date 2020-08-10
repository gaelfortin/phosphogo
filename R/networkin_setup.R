#' NetworKIN setup
#' NetworKIN is properly downloaded and installed with this function.
#' @importFrom utils unzip
#' @export
#' 
networkin_setup <- function(){
  message('Downloading NetworKIN archive...')
  download.file('https://onedrive.live.com/download?cid=38F5374142AA4416&resid=38F5374142AA4416%213566&authkey=AHQSjMEM2FKJg60', 'networkin.zip')
  message('Unzipping NetworKIN archive...')
  unzip(networkin.zip)
  system(paste0("chmod +x ", networkin_folder, "/bin/NetworKIN3.0_release/NetworKIN.py")) # Allow NetworKIN to be executed
  message('NetworKIN setup completed.')
}
