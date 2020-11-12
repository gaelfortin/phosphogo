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
#' @import ggplot2
#' @export
#' 
networkin_qc <- function(predictions_file = 'networKIN_output.tsv',
                               threshold = 0.5,
                               output_folder = 'myexperiment/'){
  predictions <- read_tsv(paste0(output_folder, predictions_file), col_types = cols()) %>%
    select(-`Target Name`,
           -`Kinase/Phosphatase/Phospho-binding domain description`,
           -`Kinase/Phosphatase/Phospho-binding domain Name`) %>%
    select("target_id" = `substrate`,
           "protein_name" = `Target description`,
           "phosphosite" = MOD_RSD,
           "kinase_phosphatase_phospho-binding" = `Kinase/Phosphatase/Phospho-binding domain`,
           "networkin_score" = `NetworKIN score`,
           "netphorest_probability" = `NetPhorest probability`,
           "family_tree" = Tree,
           "netphorest_group" = `NetPhorest Group`)
  predictions %<>%
    mutate(protein_phosphosite = str_c(target_id, phosphosite, sep = ":"))
  cumulated_scores <- predictions %>%
    count(networkin_score)
  cumulated_scores %<>%
    bind_cols(., "cumulated_count" = cumsum(cumulated_scores$n))
  total_score <- cumulated_scores$cumulated_count[nrow(cumulated_scores)]
  cumulated_scores %<>%
    mutate(count_fraction = cumulated_count/total_score)
  
  ggplot(predictions, aes(networkin_score)) +
    geom_density(kernel = "gaussian") +
    labs(title = "Distribution of scores of NetworKIN predictions.",
         caption = paste0("Number of predictions made by NetworKIN: ", nrow(predictions)),
         x = "NetworKIN score of each prediction",
         y = "Density of scores") +
    xlim(0, summary(predictions$networkin_score)[5]+2)+ #extract 3rd quartile
    theme_classic()+
    ggsave(paste0(output_folder, 'networkin_qc.pdf'))
}
