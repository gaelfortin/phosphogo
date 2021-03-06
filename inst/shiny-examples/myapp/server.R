library(shiny)
library(phosphogo)
library(tidyverse)
library(shinyDirectoryInput) # install with devtools::install_github('wleepang/shiny-directory-input')
library(plotly)

shinyServer(function(input, output, session) {
    setwd(dir = "../")
   
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
         phospho_input(
            phospho_file = input$phosphofile[1,4],
            phosphosites_column = input$phosphosite_column,
            log2_column = input$log2_column,
            fdr_column = input$fdr_column,
            output_folder = output_dir,
            species = input$species
         )
         incProgress(2/3, detail = 'Running IV-KEA')
         perform_ivkea(clean_phospho_file = 'phospho_clean.csv',
                       output_folder = output_dir)
         perform_Fisher_exact_test(predictions_file = 'ivkea_predictions.csv',
                                   predictions = "ivkea",
                                   FC_threshold = input$FC_threshold,
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
         incProgress(1/5, detail = 'Preparing data for NetworKIN')
         phospho_input(
            phospho_file = input$phosphofile[1,4],
            phosphosites_column = input$phosphosite_column,
            log2_column = input$log2_column,
            fdr_column = input$fdr_column,
            species = input$species,
            output_folder = output_dir
         )
         incProgress(2/5, detail = 'Running NetworKIN. This step may take a few minutes.')
         run_networkin(
            input_file = "phospho_clean.csv",
            output_folder = output_dir
         )
         incProgress(3/5, detail = "Generating QC graph")
         output$qc <- renderPlot(networkin_qc(
            predictions_file = 'networkin_output.csv',
            output_folder = output_dir
         ))
         incProgress(4/5, detail = 'Running statistical analysis')
         perform_Fisher_exact_test(predictions_file = 'networkin_output.csv',
                                   predictions = "networkin",
                                   FC_threshold = input$FC_threshold,
                                   output_folder = output_dir)
         incProgress(5/5, detail = 'Generating results plots')
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
         actionButton("generate_graph", label = "Generate graph", class="btn btn-primary", style = "margin-bottom:20px"))
         )
   
   ## Generate graph
   observeEvent(input$generate_graph, {
      withProgress(message = 'Rendering your plot...', value = 0, {
         incProgress(1/1)
         if (input$graph_type == "enrichment") {
            graph_data <- read_csv(input$enrichment_file[1,4], col_types= cols()) 
            graph_data  <- graph_data %>% 
               mutate(cutoff = ifelse(up_vs_down_FDR < 0.05, "Significant", "Not significant"),
                      up_vs_down_odds_ratio = 
                         ifelse(up_vs_down_odds_ratio == 'Inf',
                                max(graph_data$up_vs_down_odds_ratio[which(graph_data$up_vs_down_odds_ratio < Inf)]),
                                up_vs_down_odds_ratio)
                      )
            
            g <- ggplot(graph_data, aes(x = log2(up_vs_down_odds_ratio+0.0001), y = -log10(up_vs_down_FDR), label = top_predicted_kinase, col = cutoff)) +
               geom_point() +
               scale_colour_manual(name = "Significance", values = c("#333333", "#B90504")) +
               # xlim(-xlim_volcano, +xlim_volcano) +
               xlab("log2(odds ratio)") +
               ylab("-log10(FDR)") +
               geom_hline(aes(yintercept = -log10(0.05)),
                          linetype = "dashed",
                          colour = "#FF6347") +
               geom_vline(xintercept = 0, linetype = "dotted") +
               scale_linetype_manual(name = "Threshold", values = c("dashed"),
                                     guide = guide_legend(override.aes = list(color = c("#FF6347"))))+
               theme_classic() +
               ggtitle(input$graph_title)
               output$graph <- renderPlotly(ggplotly(g))
            
                      } else {
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
         
})