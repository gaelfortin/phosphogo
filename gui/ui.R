library(shiny)
library(shinyDirectoryInput)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Phosphogo"),
    
    tabsetPanel(type = "tabs",
                tabPanel("Setup",
                         textOutput("networkin_verif"),
                         textOutput("test_dir"),
                         
                         uiOutput('networkin_install'),
                         
                         textOutput("ivkea_verif"),
                         
                         uiOutput('ivkea_install'),
                         
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
                tabPanel("Run",
                         actionButton(inputId = "run_ivkea", label = "Run IV-KEA"),
                         actionButton(inputId = "run_networkin", label = "Run NetworKIN")
                         ),
                tabPanel("Visualize",
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
                         
                         
                         
                         
                         
                         
                         
                          
                         )
                
                )
    
    
    
  
    )
)
