library(shiny)
library(shinyDirectoryInput)
library(plotly)
library(shinythemes)


navbarPage("Phosphogo", 
           position = "fixed-top",
           theme = shinytheme("flatly"), #cosmo or flatly or sandstone
                tabPanel('1. Your data',
                         
                         tags$style(type="text/css", "body {padding-top: 70px;}"),
                         fileInput("phosphofile", label = h4("Load a phosphoproteomic file"), placeholder = "Choose CSV or XLSX file"),
                         h4("Your data at a glance"),
                         tableOutput("phospho_table"),
                         textInput("phosphosite_column", label = h4("Enter the name of the phosphosite colum"), value = "PhosphoSite"),
                         textInput("log2_column", label = h4("Enter the name of the Log2 colum"), value = "Log2"),
                         textInput("fdr_column", label = h4("Enter the name of the FDR colum"), value = "Adj. Pvalue"),
                         radioButtons("species", label = h4("Select a species"),
                                      choices = list("Human" = "hsa", "Mouse" = "mmu"), 
                                      selected = "hsa"),
                         directoryInput('output_dir', label = h4('Select a directory to save outputs'), value = '~'),
                         HTML("<i> All outputs (including tables, quality control plots and graphs will be stored in this folder. </i>")
                         ),
                tabPanel("2. Analyze",
                         h4('Select the fold change threshold to use in the analysis'),
                         numericInput("FC_threshold", label = 'Fold change threshold (from 0 to 5)', value = 1, min = 0, max = 5, step = 0.1),
                         HTML("<p>Phosphosites below this threshold will not be taken into account when comparing kinase predictions for upregulated and downregulated phosphosites. </p>
                         <p><i>A fold change threshold of 1 will select only phosphosites having a log2(ratio)>1 or log2(ratio)<-1 (i.e. one condition twice more enriched in this site than the other one).</i></p>"),
                         HTML('<p> </p>
                              <p><h4>Run prediction algorithms</h4></p>'),
                         span(textOutput("networkin_os2"), style="color:red"),
                         actionButton(inputId = "run_ivkea", label = "Run IV-KEA", class="btn btn-primary", style = "margin-bottom:20px"),
                         actionButton(inputId = "run_networkin", label = "Run NetworKIN", class="btn btn-primary", style = "margin-bottom:20px"),
                         plotOutput("qc")
                         ),
                tabPanel("3. Visualize",
                        sidebarLayout(
                            sidebarPanel(h4("Graph settings"),
                                         radioButtons("graph_type", label = "Type of graph", 
                                                      choices = list("Enrichment graph" = "enrichment", "Predictions comparison graph" = "comparison"), 
                                                      selected = "enrichment"),
                                         uiOutput('plot_data')
                                        ),
                            mainPanel(
                              plotlyOutput("graph", height = "600px")
                            )
                          )
                        ),
                tabPanel("4. Interpret",
                         sidebarLayout(
                           
                           sidebarPanel(
                             h4("Import data"),
                             fileInput('kinase_enrichments', 'Choose one or several kinase enrichment files', accept=c('.csv'), multiple = TRUE),
                             h4("Dependency analysis settings"),
                             numericInput("dep_threshold", label = "Dependency score threshold", value = -0.2),
                             numericInput("func_threshold", label = "Functional score threshold", value = 0.25, min = 0),
                             actionButton(inputId = "run_dep", label = "Run dependency analysis", class="btn btn-primary", style = "margin-bottom:20px")
                           ),
                           mainPanel(
                             HTML("<p><i> You can visualize here the results of the dependency analysis.</i></p>"),
                             tabsetPanel(
                               type = "tabs",
                               tabPanel(
                                 "Essential deregulated kinases",
                                 DT::dataTableOutput("dep_k")
                               ),
                               tabPanel(
                                 "Dependency graph of essential kinases",
                                 plotOutput("dep_g")
                               ),
                               tabPanel(
                                 "Dependency analysis details",
                                 DT::dataTableOutput("dep_details")
                               )
                             )
                           )
                         )
                ),
                navbarMenu("More",
                           tabPanel("Tutorial",
                                    includeMarkdown("tutorial.md")
                                    ),
                           tabPanel("About",
                                    includeMarkdown("about.md")
                           
                           
                           
                           )
                
                )
    
)
    
  
  

