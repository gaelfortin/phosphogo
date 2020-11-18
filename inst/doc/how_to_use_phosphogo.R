## ---- include = FALSE----------------------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  library(phosphogo)
#  phosphogoApp()

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  library(phosphogo)
#  dir.create('myexperiment', showWarnings = FALSE)

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  # Human phosphoproteomic data
#  phospho_input(
#    phospho_file = "phospho_human.xlsx",
#    phosphosites_column = "PhosphoSite",
#    log2_column = "Log2",
#    fdr_column = "Adj. Pvalue",
#    species = 'hsa',
#    output_folder = 'myexperiment/'
#  )
#  
#  # Mouse phosphoproteomic data
#  phospho_input(
#    phospho_file = "phospho_mouse.xlsx",
#    phosphosites_column = "ProteinID-Phospho:Site",
#    log2_column = "Log2",
#    fdr_column = "Adj. Pvalue",
#    species = 'mmu',
#    output_folder = 'myexperiment/'
#  )

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  run_networkin(
#    input_file = "networKIN_input.res",
#    output_folder = "myexperiment/"
#  )

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  networkin_qc(predictions_file = 'networkin_output.csv',
#               output_folder = 'myexperiment/')

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  perform_Fisher_exact_test(predictions_file = 'networkin_output.csv',
#                                predictions = "networkin",
#                                output_folder = "myexperiment/",
#                                FC_threshold = 1.2)

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_networkin.csv',
#                    odds_ratio = up_vs_down_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = up_vs_down_FDR,
#                    graph_title = "Kinases prediction enrichment (NetworKIN) up vs down",
#                    x_axis_title = "log2(odds ratio)",
#                    output_folder = "myexperiment/",
#                    file_name = "up_down_volcano_plot_networkin.pdf")
#  make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_networkin.csv',
#                    odds_ratio = up_vs_tot_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = up_vs_tot_FDR,
#                    graph_title = "Kinases prediction enrichment (NetworKIN) up vs tot",
#                    x_axis_title = "log2(odds ratio)",
#                    output_folder = 'myexperiment/',
#                    file_name = "up_tot_volcano_plot_networkin.pdf")
#  make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_networkin.csv',
#                    odds_ratio = down_vs_tot_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = down_vs_tot_FDR,
#                    graph_title = "Kinases prediction enrichment (NetworKIN) down vs tot",
#                    x_axis_title = "log2(odds ratio)",
#                    output_folder = 'myexperiment/',
#                    file_name = "down_tot_volcano_plot_networkin.pdf")

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  perform_ivkea(clean_phospho_file = 'phospho_clean.csv',
#                            output_folder = 'myexperiment/')

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  perform_Fisher_exact_test(top_predictions_file = 'ivkea_predictions.csv',
#                                predictions = "ivkea",
#                                output_folder = 'myexperiment/',
#                                FC_threshold = 1.2)

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_ivkea.csv',
#                    odds_ratio = up_vs_down_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = up_vs_down_FDR,
#                    graph_title = "Kinases prediction enrichment (IV-KEA) up vs down",
#                    x_axis_title = "log2(odds ratio)",
#                    output_folder = 'myexperiment/',
#                    file_name = "up_down_volcano_plot_ivkea.pdf")
#  make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_ivkea.csv',
#                    odds_ratio = up_vs_tot_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = up_vs_tot_FDR,
#                    graph_title = "Kinases prediction enrichment (IV-KEA) up vs tot",
#                    x_axis_title = "log2(odds ratio)",
#                    output_folder = 'myexperiment/',
#                    file_name = "up_tot_volcano_plot_ivkea.pdf")
#  make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_ivkea.csv',
#                    odds_ratio = down_vs_tot_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = down_vs_tot_FDR,
#                    graph_title = "Kinases prediction enrichment (IV-KEA) down vs tot",
#                    x_axis_title = "log2(odds ratio)",
#                    output_folder = 'myexperiment/',
#                    file_name = "down_tot_volcano_plot_ivkea.pdf")

## ----eval=FALSE----------------------------------------------------------------------------------------------------
#  predictions_comparison(
#    ivkea_enrichment_file = 'myexperiment/kinase_enrichment_ivkea.csv',
#    networkin_enrichment_file = 'myexperiment/kinase_enrichment_networkin.csv',
#    FDR_cutoff = 0.05,
#    graph_title = "Kinases prediction enrichment up vs down networkin vs iv-kea",
#    output_folder = 'myexperiment/',
#    file_name = "comp_plot.pdf"
#  )

