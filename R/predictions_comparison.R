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
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @import ggplot2
#' @export

predictions_comparison <- function(ivkea_enrichment_file,
                                   networkin_enrichment_file,
                                    FDR_cutoff = 0.05,
                                    graph_title = "Kinases prediction enrichment Networkin vs IV-KEA",
                                    output_folder = 'data/',
                                    file_name){
  iv_kea <- read_csv(paste0(output_folder, ivkea_enrichment_file)) %>%  
    filter(up_vs_down_FDR <= FDR_cutoff) %>% 
    select(top_predicted_kinase, "up_vs_down_odds_ratio") %>% 
    bind_cols("Prediction algorithm" = "IV-KEA")
  networkin <- read_csv(paste0(output_folder, networkin_enrichment_file)) %>%  
    filter(up_vs_down_FDR <= FDR_cutoff) %>%
    select(top_predicted_kinase, "up_vs_down_odds_ratio") %>%  
    bind_cols("Prediction algorithm" = "NetworKIN")
  
  bind_rows(networkin, iv_kea) %>% 
    ggplot(aes(x=top_predicted_kinase, y=up_vs_down_odds_ratio, fill=`Prediction algorithm`)) +
    geom_bar(stat="identity", position=position_dodge()) +
    coord_flip()+
    theme_classic()+
    theme(axis.line.y = element_blank(),
          axis.ticks.y = element_blank()) +
    xlab("Enrichment scores") +
    ylab("Kinase") +
    geom_hline(yintercept = 0, size = 0.5) + 
    ggtitle(graph_title) +
    ggsave(paste0(output_folder, file_name))
}
