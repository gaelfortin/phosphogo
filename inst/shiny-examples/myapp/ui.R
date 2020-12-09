library(shiny)
library(shinyDirectoryInput)
library(plotly)
library(shinythemes)


navbarPage("Phosphogo",
  theme = shinytheme("flatly"), #cosmo or flatly or sandstone
                tabPanel('1. Your data',
                         fileInput("phosphofile", label = h3("Phosphoproteomic input"), placeholder = "Choose CSV or XLSX file"),
                         h3("Your data at a glance"),
                         tableOutput("phospho_table"),
                         textInput("phosphosite_column", label = h3("Enter the name of the phosphosite colum"), value = "PhosphoSite"),
                         textInput("log2_column", label = h3("Enter the name of the Log2 colum"), value = "Log2"),
                         textInput("fdr_column", label = h3("Enter the name of the FDR colum"), value = "Adj. Pvalue"),
                         radioButtons("species", label = h3("Select a species"),
                                      choices = list("Human" = "hsa", "Mouse" = "mmu"), 
                                      selected = "hsa"),
                         directoryInput('output_dir', label = 'Select a directory to save all outputs', value = '~'),
                         ),
                tabPanel("2. Analyze",
                         h3('Select the fold change threshold to use in the analysis.'),
                         h4('Phosphosites below this threshold will not be taken into account when comparing kinase predictions for upregulated and downregulated phosphosites.'),
                         sliderInput('FC_threshold', label = 'Fold change threshold', min = 0, max = 5, value = 1, step = 0.1),
                         HTML("<i>A fold change threshold of 1 will select only phosphosites having a Log2(ratio)>1 or Log2(ratio)<-1 (i.e. one condition twice more enriched in this site than the other one).</i>"),
                         h3('Analyze only top predictions of each phosphosite (NetworKIN only)'),
                         HTML('<i> If ticked, only the top predictions made by NetworKIN for each phosphosite will be used for statistical analysis.</i>'),
                         HTML('<i> If unticked, all predictions made by NetworKIN for each phosphosite will be used.</i>'),
                         h3('Run prediction algorithms'),
                         span(textOutput("networkin_os2"), style="color:red"),
                         actionButton(inputId = "run_ivkea", label = "Run IV-KEA", class="btn btn-primary", style = "margin-bottom:20px"),
                         actionButton(inputId = "run_networkin", label = "Run NetworKIN", class="btn btn-primary", style = "margin-bottom:20px"),
                         plotOutput("qc")
                         ),
                tabPanel("3. Visualize",
                        sidebarLayout(
                            sidebarPanel("Settings",
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
                             h3("Import data"),
                             fileInput('kinase_enrichments', 'Choose one or several kinase enrichment files', accept=c('.csv'), multiple = TRUE),
                             h3("Dependency analysis settings"),
                             numericInput("dep_threshold", label = "Dependency score threshold", value = -0.2),
                             numericInput("func_threshold", label = "Functional score threshold", value = 0.25),
                             actionButton(inputId = "run_dep", label = "Run dependency analysis", class="btn btn-primary", style = "margin-bottom:20px")
                           ),
                           mainPanel(
                             tabsetPanel(
                               type = "tabs",
                               tabPanel(
                                 "Essential deregulated kinases",
                                 DT::dataTableOutput("dep_k")
                               ),
                               tabPanel(
                                 "Dependency graphs of essential kinases",
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
    
  
  

