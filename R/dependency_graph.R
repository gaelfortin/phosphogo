#' Dependency analysis visualization
#' 
#' Draw a volcano plot from any test results
#' @param dependency_data_output `<dataframe>` Output of the dependency_data function
#' @import readr
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @import ggplot2
#' @import ggridges
#' @export

dependency_graph <- function(dependency_data_output){
  g <- dependency_data_output %>% 
    ggplot(aes(x = dependency, y = combination, fill = combination)) +
    theme(legend.position = "none")+
    geom_density_ridges() +
    stat_density_ridges(quantile_lines = TRUE, quantiles = 2)
  theme_ridges() 
  return(g)
}

