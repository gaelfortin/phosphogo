#' Make volcano plot
#' 
#' Draw a volcano plot from any test results
#' @param kinase_enrichment_file `<character>` Location of the file with Fisher exact test results
#' @param odds_ratio `<column_name>` Unquoted name of the `kinase_enrichment_file` column
#' that contains the odds ratios.
#' @param FDR_cutoff `<numeric>` Cutoff to display.
#' @param FDR_data `<column_name>` Unquoted name of `kinase_enrichment_file` column
#' that contains the FDR values.
#' @param labels `<column_name>` Unquoted name of `kinase_enrichment_file` column
#' that contains the labels.
#' @param graph_title `<character>`
#' @param x_axis_title `<character>`
#' @param output_folder `<character>` Where the output files should be stored
#' @param file_name `<character>` File name including extension (.pdf recommended)
#' @import readr
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @import ggrepel
#' @import ggplot2
#' @export

make_volcano_plot <- function(kinase_enrichment_file = 'networkin_kinase_enrichment.csv',
                              odds_ratio = odds_ratio,
                              FDR_cutoff = 0.05,
                              FDR_data = FDR,
                              labels = top_predicted_kinase,
                              graph_title = "Volcano plot",
                              x_axis_title = "X axis",
                              output_folder = 'myexperiment/',
                              file_name){
  contingency_table <- read_csv(paste0(output_folder, kinase_enrichment_file), col_types = cols())
  odds_ratio <- enquo(odds_ratio)
  FDR_data <- enquo(FDR_data)
  labels <- enquo(labels)
  contingency_table %<>%
    mutate(cutoff = if_else(condition = !!FDR_data < FDR_cutoff, true = "signif", false = "not signif")) %>%
    arrange(!!FDR_data)

  significant_kinases <- filter(contingency_table, cutoff == "signif")

  contingency_table %>%
    ggplot(aes(x = log2(!!odds_ratio), y = -log10(!!FDR_data), col = cutoff)) +
    geom_point() +
    scale_colour_manual(name = "Significance", values = c("#333333", "#B90504")) +
    # xlim(-xlim_volcano, +xlim_volcano) +
    xlab(x_axis_title) +
    ylab("-log10(FDR)") +
    geom_hline(aes(yintercept = -log10(FDR_cutoff),
                   linetype = paste0("adjusted p-value = ", FDR_cutoff)),
               colour = "#FF6347") +
    geom_vline(xintercept = 0, linetype = "dotted") +
    scale_linetype_manual(name = "Threshold", values = c("dashed"),
                          guide = guide_legend(override.aes = list(color = c("#FF6347")))) +
    geom_text_repel(data=significant_kinases,
                    aes(label=!!labels),
                    show.legend = FALSE) +
    theme_classic() +
    ggtitle(graph_title)+
    ggsave(paste0(output_folder, file_name), width = 10, height = 6)

}
