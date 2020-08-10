#' IV-KEA setup
#' IV-KEA database is downloaded. Run this function only for custom IV-KEA setup.
#' @param ivkea_folder `<character>` Where to download IV-KEA database
#' @importFrom readr read_csv
#' @importFrom readr write_csv
#' @export
#' 
ivkea_setup <- function(ivkea_folder = 'data/imported/'){
  message('Downloading IV-KEA...')
  ivkea_db <- read_csv('https://raw.githubusercontent.com/gaelfortin/phosphogo/master/data/imported/invitrodb.csv')
  write_csv(ivkea_db, paste0(ivkea_folder, 'invitrodb.csv'))
  message('IV-KEA setup completed.')
}
