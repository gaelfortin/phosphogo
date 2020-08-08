#' Filter NetworKIN predictions
#' NetworKIN predictions are filtered to keep the top 20% prediction scores.
#' @param predictions_file `<character>` Location of NetworKIN output file
#' @param threshold `<numeric>` NetworKIN prediction score threshold used
#' @param experiment `<character>` Name of the experiment to tag output files
#' @import readr
#' @import dplyr
#' @import magrittr
#' @export
#'

filter_predictions <- function(predictions_file = 'data/outputs/networKIN_output.tsv',
                               threshold = 0.8,
                              experiment = 'test'){
  predictions <- read_tsv(predictions_file, col_types = cols()) %>%
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
  predictions %<>%
    filter(networkin_score >= networkin_score_threshold)
  write_csv(predictions, paste0("data/analyses/filtered_networkin_predictions_", experiment, ".csv"))

}
