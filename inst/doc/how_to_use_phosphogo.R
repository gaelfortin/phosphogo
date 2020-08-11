## ---- include = FALSE---------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------------------------------------------------------------------------
library(phosphogo)
dir.create('data/analyses', showWarnings = FALSE) 
dir.create('data/outputs', showWarnings = FALSE)
dir.create('figures', showWarnings = FALSE)

## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------
#  networkin_setup()

## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------
#  # Human phosphoproteomic data
#  networkin_input(
#    phospho_file = "data/imported/phospho_human.xlsx",
#    phosphosites_column = "PhosphoSite",
#    log2_column = "Log2",
#    fdr_column = "Adj. Pvalue",
#    experiment = "human",
#    species = 'hsa'
#  )
#  
#  # Mouse phosphoproteomic data
#  networkin_input(
#    phospho_file = "data/imported/phospho_mouse.xlsx",
#    phosphosites_column = "ProteinID-Phospho:Site",
#    log2_column = "Log2",
#    fdr_column = "Adj. Pvalue",
#    experiment = "mouse",
#    species = 'mmu'
#  )

## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------
#  run_networkin(
#    input_file = "data/outputs/networKIN_input_human.res",
#    blastall_location = "~/blast-2.2.17/bin/blastall",
#    experiment = "human"
#  )

## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------
#  filter_predictions(
#    predictions_file = 'data/outputs/networKIN_output_human.tsv',
#    experiment = 'human'
#  )

## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------
#  select_top_predictions(predictions_file = 'data/analyses/filtered_networkin_predictions_human.csv',
#                  phospho_cleaned_file = 'data/outputs/phospho_clean_human.csv',
#                  experiment = 'human')
#  perform_Fisher_exact_test(top_predictions_file = 'data/analyses/top_predictions_human.csv',
#                                experiment = 'networkin_human')

## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------
#  make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_networkin_human.csv',
#                    odds_ratio = up_vs_down_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = up_vs_down_FDR,
#                    graph_title = "Kinases prediction enrichment (NetworKIN) up vs down",
#                    x_axis_title = "log2(odds ratio)",
#                    save_path = "figures/up_down_volcano_plot_human.pdf")
#  make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_networkin_human.csv',
#                    odds_ratio = up_vs_tot_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = up_vs_tot_FDR,
#                    graph_title = "Kinases prediction enrichment (NetworKIN) up vs tot",
#                    x_axis_title = "log2(odds ratio)",
#                    save_path = "figures/up_tot_volcano_plot_human.pdf")
#  make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_networkin_human.csv',
#                    odds_ratio = down_vs_tot_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = down_vs_tot_FDR,
#                    graph_title = "Kinases prediction enrichment (NetworKIN) down vs tot",
#                    x_axis_title = "log2(odds ratio)",
#                    save_path = "figures/down_tot_volcano_plot_human.pdf")

## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------
#  perform_ivkea(clean_phospho_file = 'data/outputs/phospho_clean_human.csv',
#                            invitrodb_file = 'data/imported/invitrodb.csv',
#                            experiment = 'human')

## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------
#  perform_Fisher_exact_test(top_predictions_file = 'data/outputs/ivkea_predictions_human.csv',
#                                experiment = 'ivkea_human')

## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------
#  make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_ivkea_human.csv',
#                    odds_ratio = up_vs_down_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = up_vs_down_FDR,
#                    graph_title = "Kinases prediction enrichment (IV-KEA) up vs down",
#                    x_axis_title = "log2(odds ratio)",
#                    save_path = "figures/up_down_volcano_plot_human_ivkea.pdf")
#  make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_ivkea_human.csv',
#                    odds_ratio = up_vs_tot_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = up_vs_tot_FDR,
#                    graph_title = "Kinases prediction enrichment (IV-KEA) up vs tot",
#                    x_axis_title = "log2(odds ratio)",
#                    save_path = "figures/up_tot_volcano_plot_ivkea_human.pdf")
#  make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_ivkea_human.csv',
#                    odds_ratio = down_vs_tot_odds_ratio,
#                    FDR_cutoff = 0.05,
#                    FDR = down_vs_tot_FDR,
#                    graph_title = "Kinases prediction enrichment (IV-KEA) down vs tot",
#                    x_axis_title = "log2(odds ratio)",
#                    save_path = "figures/down_tot_volcano_plot_ivkea_human.pdf")

