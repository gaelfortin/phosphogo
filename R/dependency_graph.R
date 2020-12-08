#' Dependency analysis visualization
#' 
#' Draw a volcano plot from any test results
#' @param dependency_data_output `<character>` Output file of `dependency_data()`
#' @param output_folder `<character>` Where the output files should be stored
#' @import readr
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @import ggplot2
#' @import ggridges
#' @export

dependency_graph <- function(dependency_data_output = "dependency_data.csv", output_folder){
  g <- read_csv(paste0(output_folder, dependency_data_output)) %>% 
    ggplot(aes(x = dependency, y = combination, fill = combination)) +
    xlab("dependency score") +
    theme(legend.position = "none")+
    geom_density_ridges() +
    stat_density_ridges(quantile_lines = TRUE, quantiles = 2) +
  	theme_ridges() +
  	ggsave(paste0(output_folder, "dependency_graph.pdf"))

  return(g)
}

