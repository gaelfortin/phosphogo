#' NetworKIN setup
#' 
#' This function downloads NetworKIN predictions database.
#' @importFrom utils unzip
#' @export
#' 
networkin_setup <- function(){
  unlink('networkin', recursive = TRUE) #Remove old networkin folder
  message('Downloading NetworKIN database...')
  download.file('https://onedrive.live.com/download?cid=38F5374142AA4416&resid=38F5374142AA4416%213819&authkey=AA7DYbPsGbtXQn8', 'predictions_networkin.Rda')
  message('NetworKIN setup completed.')
}

