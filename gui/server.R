library(shiny)
library(phosphogo)
library(tidyverse)
library(shinyDirectoryInput) # install with devtools::install_github('wleepang/shiny-directory-input')
# Test if NetworKIN is installed


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
   
})