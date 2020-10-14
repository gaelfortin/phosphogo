library(shiny)
library(phosphogo)
library(tidyverse)
library(shinyDirectoryInput) # install with devtools::install_github('wleepang/shiny-directory-input')
library(plotly)

shinyServer(function(input, output, session) {
    setwd(dir = "../")
   
   # Verify that NetworKIN is installed
   output$networkin_verif <- renderText({
       ifelse(file.exists("networkin/bin/NetworKIN3.0_release/NetworKIN.py")==TRUE, 
              "NetworKIN is properly installed.",
              "WARNING! NetworKIN is not installed.")})
   
   output$networkin_install <-
       renderUI(expr = if (file.exists("networkin/bin/NetworKIN3.0_release/NetworKIN.py")==TRUE) { 
           NULL } else {
               actionButton("run_networkin_setup", label = "Install NetworKIN")})
   
   observeEvent(
      input$run_networkin_setup, {
         networkin_setup()
         output$networkin_install <-
            renderUI(expr = if (file.exists("networkin/bin/NetworKIN3.0_release/NetworKIN.py")==TRUE) { 
               NULL } else {
                  actionButton("run_networkin_setup", label = "Install NetworKIN")})
         output$networkin_verif <- renderText({
            ifelse(file.exists("networkin/bin/NetworKIN3.0_release/NetworKIN.py")==TRUE, 
                   "NetworKIN is properly installed.",
                   "WARNING! NetworKIN is not installed.")})})
   

   # Verify that IV-KEA is installed
   output$ivkea_verif <- renderText({
      ifelse(file.exists("data/imported/invitrodb.csv")==TRUE, 
             "IV-KEA is properly installed.",
             "WARNING! IV-KEA is not installed.")})
   
   output$ivkea_install <-
      renderUI(expr = if (file.exists("data/imported/invitrodb.csv")==TRUE) { 
         NULL } else {
            actionButton("run_ivkea_setup", label = "Install IV-KEA")})
   
   observeEvent(
      input$run_ivkea_setup, {
         ivkea_setup()
         output$ivkea_install <-
            renderUI(expr = if (file.exists("data/imported/invitrodb.csv")==TRUE) { 
               NULL } else {
                  actionButton("run_ivkea_setup", label = "Install IV-KEA")})
         output$ivkea_verif <- renderText({
            ifelse(file.exists("data/imported/invitrodb.csv")==TRUE, 
                   "IV-KEA is properly installed.",
                   "WARNING! IV-KEA is not installed.")})})
   
   # Select where to save outputs
   observeEvent(
      ignoreNULL = TRUE,
      eventExpr = {
         input$output_dir
      },
      handlerExpr = {
         if (input$output_dir > 0) {
            # condition prevents handler execution on initial app launch
            
            # launch the directory selection dialog with initial path read from the widget
            output_dir <- choose.dir(default = readDirectoryInput(session, 'output_dir'))
            
            # update the widget value
            updateDirectoryInput(session, 'output_dir', value = output_dir)
         }
      }
   )
   # Run IV-KEA
   observeEvent(input$run_ivkea, {
      withProgress(message = 'Running IV-KEA', value = 0, {
         incProgress(1/3, detail = 'Preparing data for IV-KEA')
         networkin_input(
            phospho_file = input$phosphofile[1,4],
            phosphosites_column = input$phosphosite_column,
            log2_column = input$log2_column,
            fdr_column = input$fdr_column,
            experiment = "shiny",
            species = input$species
         )
         incProgress(2/3, detail = 'Running IV-KEA')
         perform_ivkea(clean_phospho_file = 'data/outputs/phospho_clean_shiny.csv',
                       invitrodb_file = 'data/imported/invitrodb.csv',
                       experiment = 'shiny')
         perform_Fisher_exact_test(top_predictions_file = 'data/outputs/ivkea_predictions_shiny.csv',
                                   experiment = 'ivkea_shiny')
         incProgress(3/3, detail = 'Generating results plots')
         make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_ivkea_shiny.csv', 
                           odds_ratio = up_vs_down_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = up_vs_down_FDR,
                           graph_title = "Kinases prediction enrichment (IV-KEA) up vs down",
                           x_axis_title = "log2(odds ratio)",
                           save_path = "figures/up_down_volcano_plot_shiny_ivkea.pdf")
         make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_ivkea_shiny.csv', 
                           odds_ratio = up_vs_tot_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = up_vs_tot_FDR,
                           graph_title = "Kinases prediction enrichment (IV-KEA) up vs tot",
                           x_axis_title = "log2(odds ratio)",
                           save_path = "figures/up_tot_volcano_plot_ivkea_shiny.pdf")
         make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_ivkea_shiny.csv', 
                           odds_ratio = down_vs_tot_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = down_vs_tot_FDR,
                           graph_title = "Kinases prediction enrichment (IV-KEA) down vs tot",
                           x_axis_title = "log2(odds ratio)",
                           save_path = "figures/down_tot_volcano_plot_ivkea_shiny.pdf")
         })
      

      
      
      
      
      
      
   })
   # Run NetworKIN
   observeEvent(input$run_networkin, {
      withProgress(message = 'Running NetworKIN', value = 0, {
         incProgress(1/6, detail = 'Preparing data for NetworKIN')
         networkin_input(
            phospho_file = input$phosphofile[1,4],
            phosphosites_column = input$phosphosite_column,
            log2_column = input$log2_column,
            fdr_column = input$fdr_column,
            experiment = "shiny",
            species = input$species
         )
         incProgress(2/6, detail = 'Running NetworKIN. This step may take up to 1 hour')
         run_networkin(
            input_file = "data/outputs/networKIN_input_shiny.res",
            blastall_location = "~/blast-2.2.17/bin/blastall",
            experiment = "shiny"
         )
         incProgress(3/6, detail = 'Filtering NetworKIN predictions')
         filter_predictions(
            predictions_file = 'data/outputs/networKIN_output_shiny.tsv',
            experiment = 'shiny'
         )
         incProgress(4/6, detail = 'Keeping only top predictions')
         select_top_predictions(predictions_file = 'data/analyses/filtered_networkin_predictions_shiny.csv',
                                phospho_cleaned_file = 'data/outputs/phospho_clean_shiny.csv',
                                experiment = 'shiny')
         incProgress(5/6, detail = 'Running statistical analysis')
         perform_Fisher_exact_test(top_predictions_file = 'data/analyses/top_predictions_shiny.csv',
                                   experiment = 'networkin_shiny')
         incProgress(6/6, detail = 'Generating results plots')
         make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_networkin_shiny.csv', 
                           odds_ratio = up_vs_down_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = up_vs_down_FDR,
                           graph_title = "Kinases prediction enrichment (IV-KEA) up vs down",
                           x_axis_title = "log2(odds ratio)",
                           save_path = "figures/up_down_volcano_plot_shiny_networkin.pdf")
         make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_networkin_shiny.csv', 
                           odds_ratio = up_vs_tot_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = up_vs_tot_FDR,
                           graph_title = "Kinases prediction enrichment (IV-KEA) up vs tot",
                           x_axis_title = "log2(odds ratio)",
                           save_path = "figures/up_tot_volcano_plot_networkin_shiny.pdf")
         make_volcano_plot(kinase_enrichment_file = 'data/analyses/kinase_enrichment_networkin_shiny.csv', 
                           odds_ratio = down_vs_tot_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = down_vs_tot_FDR,
                           graph_title = "Kinases prediction enrichment (IV-KEA) down vs tot",
                           x_axis_title = "log2(odds ratio)",
                           save_path = "figures/down_tot_volcano_plot_networkin_shiny.pdf")
      })
      
      
      
      
      
      
      
      
   })
   
   # Visualize data
   ## Input
   output$plot_data <-
      renderUI(
         tagList(if (input$graph_type == "enrichment") {
            fileInput("enrichment_file", label = h3("Enrichment results file"), placeholder = "Select a .csv file")
         } else {fileInput("networkin_file", label = h3("Networkin enrichment results file"), placeholder = "Select a .csv file")},
         if (input$graph_type != "enrichment") {fileInput("ivkea_file", label = h3("IV-KEA enrichment results file"), placeholder = "Select a .csv file")},
         textInput("graph_title", label = "Graph title", value = paste0(input$graph_type, " graph")),
         actionButton("generate_graph", label = "Generate graph"))
         )
   
   ## Generate graph
   observeEvent(input$generate_graph, {
      if (input$graph_type == "enrichment") {
         graph_data <- read_csv(input$enrichment_file[1,4], col_types= cols())
         output$graph <- renderPlotly(
            plot_ly(x = graph_data$up_vs_down_odds_ratio, y = -log10(graph_data$up_vs_down_FDR), name = graph_data$top_predicted_kinase) %>% 
            layout(title = input$graph_title,
                   xaxis = list(title = "Odds ratio"),
                   yaxis = list(title = "-log10(FDR)"))
         )} else {
               p <- predictions_comparison(
                  ivkea_enrichment_file = read_csv(input$ivkea_file[1,4]),
                  networkin_enrichment_file = read_csv(input$networkin_file[1,4]),
                  FDR_cutoff = 0.05, 
                  graph_title = "Kinases prediction enrichment up vs down networkin vs iv-kea",
                  save_path = "figures/comp_plot.pdf"
               )
               output$graph <- renderPlotly(ggplotly(p))
            }
   })
         
})