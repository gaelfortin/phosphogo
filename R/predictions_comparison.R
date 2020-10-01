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
#' @param save_path `<character>` File path to save the volcano plot in.
#' @import readr
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @import ggplot2
#' @export

predictions_comparison <- function(ivkea_enrichment_file = 'data/analyses/ivkea_kinase_enrichment.csv',
                                   networkin_enrichment_file = 'data/analyses/networkin_kinase_enrichment.csv',
                                    FDR_cutoff = 0.05,
                                    graph_title = "Kinases prediction enrichment Networkin vs IV-KEA",
                                    save_path = "figures/predictions_comparison.pdf"){
  iv_kea <- read_csv('data/analyses/kinase_enrichment_ivkea_human.csv') %>%  
    filter(up_vs_down_FDR <= FDR_cutoff) %>% 
    select(top_predicted_kinase, "up_vs_down_odds_ratio") %>% 
    bind_cols("Prediction algorithm" = "IV-KEA")
  networkin <- read_csv('data/analyses/kinase_enrichment_networkin_human.csv') %>%  
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
    ggsave(save_path)
}
