#' Perform Fisher exact test
#' 
#' This function computes Fisher exact test and the corresponding adjusted p-values (FDR)
#' for upregulated vs downregulated phosphosites, upregulated vs all phosphosites,
#' downregulated vs all phosphosites.
#' @param predictions_file `<character>` Location of the file with top predictions per phosphosite
#' @param predictions `<character>` The algorithm used for predictions (NetworKIN or IV-KEA)
#' @param output_folder `<character>` Where the output files should be stored
#' @param FC_threshold `<numeric>` Fold change threshold to select phosphosites.
#' @import readr
#' @import dplyr
#' @import tibble
#' @import tidyr
#' @importFrom purrr map2
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @importFrom rlang .data
#' @export

perform_Fisher_exact_test <- function(predictions_file = 'networkin_output.csv',
                                      predictions = "networkin",
                                      output_folder = 'myexperiment/',
                                      FC_threshold = 1.2){
  phospho_predictions <- read_csv(paste0(output_folder, predictions_file), col_types = cols())
  upreg_proteo <- phospho_predictions %>%
    filter(is.na(.data$top_predicted_kinase)==FALSE) %>%
    filter(.data$Log2 >= FC_threshold) %>%
    filter(.data$adj_pvalue < 0.05) %>%
    count(.data$top_predicted_kinase)
  downreg_proteo <- phospho_predictions %>%
    filter(is.na(.data$top_predicted_kinase)==FALSE) %>%
    filter(.data$Log2 <= -FC_threshold) %>%
    filter(.data$adj_pvalue < 0.05) %>%
    count(.data$top_predicted_kinase)
  contingency_table <- full_join(upreg_proteo, downreg_proteo, by = "top_predicted_kinase", suffix = c("_upreg", "_downreg"))
  contingency_table %<>%  replace_na(replace = list(n_upreg = 0, n_downreg = 0))
  # Fisher exact test upregulated vs downregulated phosphosites
  contingency_table %<>%
    mutate(fisher_res = map2(.x = .data$n_upreg, .y = .data$n_downreg, .f = fisher_exact_test, sum(contingency_table$n_upreg), sum(contingency_table$n_downreg))) %>%
    separate(col = .data$fisher_res, into = c("up_vs_down_pvalue", "up_vs_down_odds_ratio"), sep = ",", convert = TRUE)
  contingency_table %<>% bind_cols(up_vs_down_FDR =  p.adjust(contingency_table$up_vs_down_pvalue, method = "fdr"))
  # Fisher exact test upregulated vs all sites and downregulated vs all sites
  contingency_table %<>% # count the top predicted kinase for all sites
    left_join(count(phospho_predictions, .data$top_predicted_kinase), by = "top_predicted_kinase") %>%
    select(everything(), "n_tot" = n) 
  contingency_table %<>%
    mutate(fisher_res_up = map2(.x = .data$n_upreg, .y = .data$n_tot, .f = fisher_exact_test, sum(contingency_table$n_upreg), sum(contingency_table$n_tot)),
           fisher_res_down = map2(.x = .data$n_downreg, .y = .data$n_tot, .f = fisher_exact_test, sum(contingency_table$n_downreg), sum(contingency_table$n_tot))) %>%
    separate(col = .data$fisher_res_up, into = c("up_vs_tot_pvalue", "up_vs_tot_odds_ratio"), sep=",", convert = TRUE) %>%
    separate(col = .data$fisher_res_down, into = c("down_vs_tot_pvalue", "down_vs_tot_odds_ratio"), sep=",", convert = TRUE)
  contingency_table %<>% bind_cols(
    up_vs_tot_FDR =  p.adjust(contingency_table$up_vs_tot_pvalue, method = "fdr"),
    down_vs_tot_FDR =  p.adjust(contingency_table$down_vs_tot_pvalue, method = "fdr"))
  write_csv(contingency_table, paste0(output_folder, "kinase_enrichment_", predictions, ".csv"))
}
