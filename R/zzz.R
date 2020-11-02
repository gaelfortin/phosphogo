.onAttach <- function(libname, pkgname) {
  
  if (!("shinyDirectoryInput" %in% rownames(installed.packages()))) {
    packageStartupMessage(
      paste0(
        "Please install `shinyDirectoryInput` by",
        " `devtools::install_github('wleepang/shiny-directory-input')`"
      )
    )
  }
  
}