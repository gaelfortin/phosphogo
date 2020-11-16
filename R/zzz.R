.onAttach <- function(libname, pkgname) {
  
  if (!("shinyDirectoryInput" %in% rownames(installed.packages()))) {
    message("phosphogo application relies in part on shinyDirectoryInput.")
    message("This package will now be installed.")
    devtools::install_github('wleepang/shiny-directory-input')
  }
}