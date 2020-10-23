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
                               threshold = 0.8,
                               output_folder = 'myexperiment/'){
  predictions <- read_tsv(paste0(output_folder, predictions_file), col_types = cols()) %>%
    select(-`Target Name`,
           -`Kinase/Phosphatase/Phospho-binding domain description`,
           -`Kinase/Phosphatase/Phospho-binding domain Name`) %>%
    select("target_id" = `#Name`,
           "protein_name" = `Target description`,
           "phosphosite" = Position,
           "kinase_phosphatase_phospho-binding" = `Kinase/Phosphatase/Phospho-binding domain`,
           "networkin_score" = `NetworKIN score`,
           "netphorest_probability" = `NetPhorest probability`,
           "family_tree" = Tree,
           "netphorest_group" = `NetPhorest Group`)
  predictions %<>%
    mutate(protein_phosphosite = str_c(target_id, phosphosite, sep = ":"))
  threshold_fraction <- threshold
  cumulated_scores <- predictions %>%
    count(networkin_score)
  cumulated_scores %<>%
    bind_cols(., "cumulated_count" = cumsum(cumulated_scores$n))
  total_score <- cumulated_scores$cumulated_count[nrow(cumulated_scores)]
  cumulated_scores %<>%
    mutate(count_fraction = cumulated_count/total_score)
  networkin_score_threshold <- as.numeric(cumulated_scores %>%
                                            filter(count_fraction > threshold_fraction) %>%
                                            select(networkin_score) %>%
                                            slice(1))
  
  ggplot(predictions, aes(networkin_score)) +
    geom_density(kernel = "gaussian") +
    geom_vline(aes(xintercept = networkin_score_threshold), linetype="dashed", 
               color = "red") +
    labs(title = "Distribution of scores of NetworKIN predictions.",
         subtitle = paste0("Current NetworKIN threshold is set to select the top ", threshold*100, "% predictions."),
         caption = paste0("Number of predictions made by NetworKIN: ", nrow(predictions)),
         x = "NetworKIN score of each prediction",
         y = "Density of scores") +
    xlim(0, summary(predictions$networkin_score)[5]+2)+ #extract 3rd quartile
    theme_classic()+
    ggsave(paste0(output_folder, 'networkin_qc.pdf'))
  }