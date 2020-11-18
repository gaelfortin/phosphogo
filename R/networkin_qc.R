#' Quality control of NetworKIN predictions
#' 
#' Draw a density plot of all predictions made by NetworKIN before filtering
#' @param predictions_file `<character>` Location of NetworKIN output file
#' @param threshold `<numeric>` NetworKIN prediction score threshold used
#' @param output_folder `<character>` Where the output files should be stored
#' @import readr
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @importFrom rlang .data
#' @import ggplot2
#' @export
#' 
networkin_qc <- function(predictions_file = 'networkin_output.csv',
                               threshold = 0.5,
                               output_folder = 'myexperiment/'){
  
  predictions <- read_csv(paste0(output_folder, predictions_file), col_types = cols())
  cumulated_scores <- predictions %>%
    count(.data$networkin_score)
  cumulated_scores %<>%
    bind_cols(., "cumulated_count" = cumsum(cumulated_scores$n))
  total_score <- cumulated_scores$cumulated_count[nrow(cumulated_scores)]
  cumulated_scores %<>%
    mutate(count_fraction = .data$cumulated_count/total_score)
  
  ggplot(predictions, aes(.data$networkin_score)) +
    geom_density(kernel = "gaussian") +
    labs(title = "Distribution of scores of NetworKIN predictions.",
         caption = paste0("Number of predictions made by NetworKIN: ", nrow(predictions)),
         x = "NetworKIN score of each prediction",
         y = "Density of scores") +
    xlim(0, summary(predictions$networkin_score)[5]+2)+ #extract 3rd quartile
    theme_classic()+
    ggsave(paste0(output_folder, 'networkin_qc.pdf'))
}
