library(shiny)
library(shinyDirectoryInput)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Setup and input"),
    
    textOutput("networkin_verif"),
    
    uiOutput('networkin_install'),
    
    textOutput("ivkea_verif"),
    
    uiOutput('ivkea_install'),
    
    fileInput("phosphofile", label = h3("Phosphoproteomic input"), placeholder = "Select a .csv or .xlsx file"),
    textInput("phosphosite_column", label = h3("Enter the name of the phosphosite colum"), value = "PhosphoSite"),
    textInput("log2_column", label = h3("Enter the name of the Log2 colum"), value = "Log2"),
    textInput("fdr_column", label = h3("Enter the name of the FDR colum"), value = "Adj. Pvalue"),
    radioButtons("species", label = h3("Select a species"),
                 choices = list("Human" = "hsa", "Mouse" = "mmu"), 
                 selected = "hsa"),
    directoryInput('output_dir', label = 'Select a directory to save all outputs', value = '~'),
    
    
    actionButton(inputId = "run_ivkea", label = "Run IV-KEA")
    )
)
