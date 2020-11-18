#' Compare predictions
#' 
#' Print NetworKIN and IV-KEA predictions on the same volcano plot 
#' to compare predictions.
#' @param ivkea_enrichment_file `<character>` Location of the IV-KEA
#' file with Fisher exact test results
#' @param networkin_enrichment_file `<character>` Location of the IV-KEA
#' file with Fisher exact test results
#' @param FDR_cutoff `<numeric>` Cutoff to display.
#' @param graph_title `<character>`
#' @param output_folder `<character>` Where the output files should be stored
#' @param file_name `<character>` File name including extension (.pdf recommended)
#' @import readr
#' @import dplyr
#' @importFrom stats reorder
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @importFrom rlang .data
#' @import ggplot2
#' @export

predictions_comparison <- function(ivkea_enrichment_file,
                                   networkin_enrichment_file,
                                    FDR_cutoff = 0.05,
                                    graph_title = "Kinases prediction enrichment Networkin vs IV-KEA",
                                    output_folder = 'myexperiment/',
                                    file_name){
  iv_kea <- read_csv(ivkea_enrichment_file) %>%  
    filter(.data$up_vs_down_FDR <= FDR_cutoff) %>% 
    select(.data$top_predicted_kinase, "up_vs_down_odds_ratio") %>% 
    bind_cols("Prediction algorithm" = "IV-KEA")
  networkin <- read_csv(networkin_enrichment_file) %>%  
    filter(.data$up_vs_down_FDR <= FDR_cutoff) %>%
    select(.data$top_predicted_kinase, "up_vs_down_odds_ratio") %>%  
    bind_cols("Prediction algorithm" = "NetworKIN")
  
  merged <- bind_rows(networkin, iv_kea) 
  merged %>% 
    mutate(up_vs_down_odds_ratio = 
             ifelse(.data$up_vs_down_odds_ratio == 'Inf',
                    max(merged$up_vs_down_odds_ratio[which(merged$up_vs_down_odds_ratio < Inf)]),
                    .data$up_vs_down_odds_ratio)) %>% 
    ggplot(aes(x=reorder(.data$top_predicted_kinase, log2(.data$up_vs_down_odds_ratio)), y=log2(.data$up_vs_down_odds_ratio+0.0001), fill=.data$`Prediction algorithm`)) +
    geom_bar(stat="identity", position=position_dodge()) +
    coord_flip()+
    theme_classic()+
    theme(axis.line.y = element_blank(),
          axis.ticks.y = element_blank()) +
    xlab("Kinases") +
    ylab("Enrichment scores in log2") +
    geom_hline(yintercept = 0, size = 0.5)+ 
    ggtitle(graph_title) +
    ggsave(paste0(output_folder, file_name))
}
