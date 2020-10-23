library(shiny)
library(phosphogo)
library(tidyverse)
library(shinyDirectoryInput) # install with devtools::install_github('wleepang/shiny-directory-input')
library(plotly)

shinyServer(function(input, output, session) {
    setwd(dir = "../")
   
   # Verify that NetworKIN and IV-KEA are installed
   output$networkin_verif <- renderText({
       ifelse(file.exists("networkin/bin/NetworKIN3.0_release/NetworKIN.py")==TRUE, 
              "NetworKIN is properly installed.",
              "WARNING! NetworKIN is not installed.")})
   output$ivkea_verif <- renderText({
      ifelse(file.exists("invitrodb.csv")==TRUE, 
             "IV-KEA is properly installed.",
             "WARNING! IV-KEA is not installed.")})
   
   #Install NetworKIN and IV-KEA
   observeEvent(
      input$install, {
       if (input$install_networkin == TRUE) {
          withProgress(message = 'Installing NetworKIN...', value = 0,
                       {incProgress(1/1)
                        networkin_setup()})}
       if (input$install_ivkea) {
          withProgress(message = 'Installing IV-KEA', value = 0,
                       {incProgress(1/1)
                        ivkea_setup()})}
      output$networkin_verif <- renderText({
         ifelse(file.exists("networkin/bin/NetworKIN3.0_release/NetworKIN.py")==TRUE, 
                "NetworKIN is properly installed.",
                "WARNING! NetworKIN is not installed.")})
      output$ivkea_verif <- renderText({
         ifelse(file.exists("invitrodb.csv")==TRUE, 
                "IV-KEA is properly installed.",
                "WARNING! IV-KEA is not installed.")})  
         
      })
   
   
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
   
   
   output$ivkea_install <-
      renderUI(expr = if (file.exists("data/imports/invitrodb.csv")==TRUE) { 
         NULL } else {
            actionButton("run_ivkea_setup", label = "Install IV-KEA")})
   
   observeEvent(
      input$run_ivkea_setup, {
         ivkea_setup()
         output$ivkea_install <-
            renderUI(expr = if (file.exists("data/imports/invitrodb.csv")==TRUE) { 
               NULL } else {
                  actionButton("run_ivkea_setup", label = "Install IV-KEA")})
         output$ivkea_verif <- renderText({
            ifelse(file.exists("data/imports/invitrodb.csv")==TRUE, 
                   "IV-KEA is properly installed.",
                   "WARNING! IV-KEA is not installed.")})})
   
   # Render phospho data to help to input proper column headers
   output$phospho_table <- renderUI({
      # input$file1 will be NULL initially. After the user selects
      # and uploads a file, it will be a data frame with 'name',
      # 'size', 'type', and 'datapath' columns. The 'datapath'
      # column will contain the local filenames where the data can
      # be found.
      
      tagList(
         renderText({
            inFile <- input$phosphofile
            ifelse(is.null(inFile), "Please select the file containing your data.", "First lines of your data:")
         }),
         renderTable({
            inFile <- input$phosphofile
      if (is.null(inFile))
         return(NULL)
      
      if (str_detect(inFile$datapath, "csv")) {
         head(read_csv(inFile$datapath))
      } else {head(readxl::read_xlsx(inFile$datapath))}
      })
   )})
   
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
      output_dir <- paste0(readDirectoryInput(session, 'output_dir'), '/')
      withProgress(message = 'Running IV-KEA', value = 0, {
         incProgress(1/3, detail = 'Preparing data for IV-KEA')
         networkin_input(
            phospho_file = input$phosphofile[1,4],
            phosphosites_column = input$phosphosite_column,
            log2_column = input$log2_column,
            fdr_column = input$fdr_column,
            output_folder = output_dir,
            species = input$species
         )
         incProgress(2/3, detail = 'Running IV-KEA')
         perform_ivkea(clean_phospho_file = 'phospho_clean.csv',
                       invitrodb_file = 'data/imports/invitrodb.csv',
                       output_folder = output_dir)
         perform_Fisher_exact_test(top_predictions_file = 'ivkea_predictions.csv',
                                   predictions = "ivkea",
                                   output_folder = output_dir)
         incProgress(3/3, detail = 'Generating results plots')
         make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_ivkea.csv', 
                           odds_ratio = up_vs_down_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = up_vs_down_FDR,
                           graph_title = "Kinases prediction enrichment (IV-KEA) up vs down",
                           x_axis_title = "log2(odds ratio)",
                           output_folder = output_dir,
                           file_name = "up_down_volcano_plot_ivkea.pdf")
         make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_ivkea.csv', 
                           odds_ratio = up_vs_tot_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = up_vs_tot_FDR,
                           graph_title = "Kinases prediction enrichment (IV-KEA) up vs tot",
                           x_axis_title = "log2(odds ratio)",
                           output_folder = output_dir,
                           file_name = "up_tot_volcano_plot_ivkea.pdf")
         make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_ivkea.csv', 
                           odds_ratio = down_vs_tot_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = down_vs_tot_FDR,
                           graph_title = "Kinases prediction enrichment (IV-KEA) down vs tot",
                           x_axis_title = "log2(odds ratio)",
                           output_folder = output_dir,
                           file_name = "down_tot_volcano_plot_ivkea.pdf")
         })
      

      
      
      
      
      
      
   })
   # Run NetworKIN
   observeEvent(input$run_networkin, {
      output_dir <- paste0(readDirectoryInput(session, 'output_dir'), '/')
      withProgress(message = 'Running NetworKIN', value = 0, {
         incProgress(1/6, detail = 'Preparing data for NetworKIN')
         networkin_input(
            phospho_file = input$phosphofile[1,4],
            phosphosites_column = input$phosphosite_column,
            log2_column = input$log2_column,
            fdr_column = input$fdr_column,
            species = input$species,
            output_folder = output_dir
         )
         incProgress(2/6, detail = 'Running NetworKIN. This step may take up to 1 hour')
         run_networkin(
            input_file = "networKIN_input.res",
            blastall_location = "~/blast-2.2.17/bin/blastall",
            output_folder = output_dir
         )
         incProgress(3/6, detail = 'Filtering NetworKIN predictions')
         filter_predictions(
            predictions_file = 'networKIN_output.tsv',
            output_folder = output_dir
         )
         incProgress(4/6, detail = 'Keeping only top predictions')
         select_top_predictions(predictions_file = 'filtered_networkin_predictions.csv',
                                phospho_cleaned_file = 'phospho_clean.csv',
                                output_folder = output_dir)
         incProgress(5/6, detail = 'Running statistical analysis')
         perform_Fisher_exact_test(top_predictions_file = 'top_predictions.csv',
                                   predictions = "networkin",
                                   output_folder = output_dir)
         incProgress(6/6, detail = 'Generating results plots')
         make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_networkin.csv', 
                           odds_ratio = up_vs_down_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = up_vs_down_FDR,
                           graph_title = "Kinases prediction enrichment (NetworKIN) up vs down",
                           x_axis_title = "log2(odds ratio)",
                           output_folder = output_dir,
                           file_name = "up_down_volcano_plot_networkin.pdf")
         make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_networkin.csv', 
                           odds_ratio = up_vs_tot_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = up_vs_tot_FDR,
                           graph_title = "Kinases prediction enrichment (NetworKIN) up vs tot",
                           x_axis_title = "log2(odds ratio)",
                           output_folder = output_dir,
                           file_name = "up_tot_volcano_plot_networkin.pdf")
         make_volcano_plot(kinase_enrichment_file = 'kinase_enrichment_networkin.csv', 
                           odds_ratio = down_vs_tot_odds_ratio,
                           FDR_cutoff = 0.05, 
                           FDR = down_vs_tot_FDR,
                           graph_title = "Kinases prediction enrichment (NetworKIN) down vs tot",
                           x_axis_title = "log2(odds ratio)",
                           output_folder = output_dir,
                           file_name = "down_tot_volcano_plot_networkin.pdf")
      })
      
      
      
      
      
      
      
      
   })
   
   # Visualize data
   ## Input
   output$plot_data <-
      renderUI(
         tagList(if (input$graph_type == "enrichment") {
            fileInput("enrichment_file", label = h3("Enrichment results file"), placeholder = "Select a .csv file")
         } else {fileInput("networkin_file", label = h3("Networkin enrichment results file"), placeholder = "Select NetworKIN enrichment results")},
         if (input$graph_type != "enrichment") {fileInput("ivkea_file", label = h3("IV-KEA enrichment results file"), placeholder = "Select IV-KEA enrichment results")},
         textInput("graph_title", label = "Graph title", value = paste0(input$graph_type, " graph")),
         actionButton("generate_graph", label = "Generate graph"))
         )
   
   ## Generate graph
   observeEvent(input$generate_graph, {
      if (input$graph_type == "enrichment") {
         graph_data <- read_csv(input$enrichment_file[1,4], col_types= cols())
         output$graph <- renderPlotly(
            plot_ly(x = log2(graph_data$up_vs_down_odds_ratio), y = -log10(graph_data$up_vs_down_FDR), name = graph_data$top_predicted_kinase) %>% 
            layout(title = input$graph_title,
                   xaxis = list(title = "log2(Odds ratio)"),
                   yaxis = list(title = "-log10(FDR)"))
         )} else {
            output_dir <- paste0(readDirectoryInput(session, 'output_dir'), '/')
               p <- predictions_comparison(
                  ivkea_enrichment_file = input$ivkea_file[1,4],
                  networkin_enrichment_file = input$networkin_file[1,4],
                  FDR_cutoff = 0.05, 
                  graph_title = input$graph_title,
                  output_folder = output_dir,
                  file_name = "comp_plot.pdf"
               )
               output$graph <- renderPlotly(ggplotly(p))
            }
   })
         
})