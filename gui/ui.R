library(shiny)
library(shinyDirectoryInput)
library(plotly)
library(shinythemes)


navbarPage("Phosphogo",
  theme = shinytheme("flatly"), #cosmo or flatly or sandstone
                tabPanel("0. Setup",
                         h3("Install / reinstall prediction softwares"),
                         h4("Current status of NetworKIN and IV-KEA:"),
                         textOutput("networkin_verif"),
                         textOutput("ivkea_verif"),
                         h4("Choose which prediction software(s) should be installed:"),
                         checkboxInput("install_networkin", label = "NetworKIN", value = TRUE),
                         checkboxInput("install_ivkea", label = "IV-KEA", value = TRUE),
                         actionButton("install", label = "Install", class="btn btn-primary", style = "margin-bottom:20px"),
                         ),
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
                tabPanel("2. Run",
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
                              plotlyOutput("graph")
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
    
  
  

