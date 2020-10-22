#' Dependencies setup
#' 
#' This script installs IVKEA and NetworKIN in the current directory
#' @param networkin `<bolean>` Whether to install NetworKIN or not
#' @param ivkea `<bolean>` Whether to install IV-KEA or not
#' @export
#' 

dependencies_setup <- function(networkin = TRUE, ivkea = TRUE){
  if (ivkea == TRUE) {
    message('Installing IV-KEA...')
    ivkea_setup(ivkea_folder = '')
  }
  if (networkin == TRUE) {
    message('Installing NetworKIN...')
    networkin_setup()
  }
}