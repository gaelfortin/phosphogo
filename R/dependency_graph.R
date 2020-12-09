#' Dependency analysis visualization
#' 
#' Draw the dependency distribution of deregulated kinases in given cell lines. 
#' Only the top 20 dependent kinase-cell line combinations are shown.
#' @param dependency_data_output `<character>` Output file of `dependency_data()`
#' @param output_folder `<character>` Where the output files should be stored
#' @import readr
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @import ggplot2
#' @import ggridges
#' @export

dependency_graph <- function(dependency_data_output = "dependency_data.csv", output_folder){
  data <- read_csv(paste0(output_folder, dependency_data_output)) 
  data %>% 
    ggplot(aes(x = dependency, y = combination, fill = stat(x))) +
    geom_density_ridges_gradient(rel_min_height = 0.01) +
    scale_fill_viridis_c(name = "Dependency score", option = "C") +
    xlab("Dependency score") +
    ylab("Combination") +
    theme_ridges() +
    stat_density_ridges(geom = "density_ridges_gradient", calc_ecdf = TRUE,
                        quantile_lines = TRUE, quantiles = 2) +
  	ggsave(paste0(output_folder, "dependency_graph.pdf"), width = 20, height = length(unique(data$combination))*0.5, units = "cm")

  return(g)
}
