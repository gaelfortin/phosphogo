#' NetworKIN setup
#' NetworKIN is properly setup with this function.
#' @param networkin_zip `<character>` Location of the networkin.zip
#' archive to be installed.
#' @param networkin_folder `<character>` Location in which NetworKIN will be
#' installed. By default, NetworKIN is installed in the R project main folder
#' from networkin.zip (also in the main folder). For an example, 
#' see the project architecture at https://github.com/gaelfortin/phosphogo
#' @importFrom utils unzip
#' @export
#' 
networkin_setup <- function(networkin_zip = 'networkin.zip',
                            networkin_folder = 'networkin'){
  message('Unzipping NetworKIN archive...')
  unzip(networkin_zip)
  system(paste0("chmod +x ", networkin_folder, "/bin/NetworKIN3.0_release/NetworKIN.py")) # Allow NetworKIN to be executed
  message('NetworKIN setup completed.')
}
