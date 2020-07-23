#' Perform Fisher exact test
#' This function computes Fisher exact test and the corresponding adjusted p-values (FDR)
#' for upregulated vs downregulated phosphosites, upregulated vs all phosphosites, 
#' downregulated vs all phosphosites.
#' @param top_predictions_file `<character>` Location of the file with top predictions per phosphosite 
#' @param experiment `<character>` Name of the experiment to tag output files
#' @export

perform_Fisher_exact_test <- function(top_predictions_file = 'data/analyses/top_predictions.csv',
                              experiment = 'test'){
  require(tidyverse)
  require(magrittr)
  phospho_predictions <- read_csv(top_predictions_file, col_types = cols())
  upreg_proteo <- phospho_predictions %>% 
    filter(is.na(top_predicted_kinase)==FALSE) %>% 
    filter(Log2 > 0) %>% 
    filter(adj_pvalue < 0.05) %>% 
    count(top_predicted_kinase)
  downreg_proteo <- phospho_predictions %>% 
    filter(is.na(top_predicted_kinase)==FALSE) %>% 
    filter(Log2 < 0) %>% 
    filter(adj_pvalue < 0.05) %>% 
    count(top_predicted_kinase)
  contingency_table <- full_join(upreg_proteo, downreg_proteo, by = "top_predicted_kinase", suffix = c("_upreg", "_downreg"))
  contingency_table %<>%  replace_na(replace = list(n_upreg = 0, n_downreg = 0))
  contingency_table %<>% 
    remove_rownames() %>% 
    column_to_rownames("top_predicted_kinase")
  source("R/fisher_exact_test.R")
  # Fisher exact test upregulated vs downregulated phosphosites
  contingency_table %<>% 
    mutate(fisher_res = map2(.x = n_upreg, .y = n_downreg, .f = fisher_exact_test, sum(contingency_table$n_upreg), sum(contingency_table$n_downreg))) %>% 
    separate(col = fisher_res, into = c("up_vs_down_pvalue", "up_vs_down_odds_ratio"), sep = ",", convert = TRUE)
  contingency_table %<>% bind_cols(up_vs_down_FDR =  p.adjust(contingency_table$up_vs_down_pvalue, method = "fdr")) 
  # Fisher exact test upregulated vs all sites and downregulated vs all sites
  contingency_table %<>% # count the top predicted kinase for all sites 
    rownames_to_column("top_predicted_kinase") %>% 
    left_join(count(phospho_predictions, top_predicted_kinase)) %>% 
    select(everything(), "n_tot" = n) %>% 
    column_to_rownames("top_predicted_kinase")
  contingency_table %<>% 
    mutate(fisher_res_up = map2(.x = n_upreg, .y = n_tot, .f = fisher_exact_test, sum(contingency_table$n_upreg), sum(contingency_table$n_tot)),
           fisher_res_down = map2(.x = n_downreg, .y = n_tot, .f = fisher_exact_test, sum(contingency_table$n_downreg), sum(contingency_table$n_tot))) %>% 
    separate(col = fisher_res_up, into = c("up_vs_tot_pvalue", "up_vs_tot_odds_ratio"), sep=",", convert = TRUE) %>% 
    separate(col = fisher_res_down, into = c("down_vs_tot_pvalue", "down_vs_tot_odds_ratio"), sep=",", convert = TRUE)
  contingency_table %<>% bind_cols(
    up_vs_tot_FDR =  p.adjust(contingency_table$up_vs_tot_pvalue, method = "fdr"),
    down_vs_tot_FDR =  p.adjust(contingency_table$down_vs_tot_pvalue, method = "fdr"))%>% 
    rownames_to_column(var = "top_predicted_kinase")
  write_csv(contingency_table, paste0("data/analyses/networkin_kinase_enrichment_", experiment, ".csv"))
}