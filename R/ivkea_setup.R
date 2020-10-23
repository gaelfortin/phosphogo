#' IV-KEA setup
#' 
#' IV-KEA database is downloaded. Run this function only for custom IV-KEA setup.
#' @param ivkea_folder `<character>` Where to download IV-KEA database
#' @importFrom readr read_csv
#' @importFrom readr write_csv
#' @export
#' 
ivkea_setup <- function(ivkea_folder = ''){
  message('Downloading IV-KEA...')
  ivkea_db <- read_csv('https://onedrive.live.com/download?cid=38F5374142AA4416&resid=38F5374142AA4416%213702&authkey=AKbXsVkfod3C3uc')
  write_csv(ivkea_db, 'invitrodb.csv')
  message('IV-KEA setup completed.')
}
