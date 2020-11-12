#' Generate a clean phosphoproteomic file for NetworKIN and IV-KEA
#' 
#' This function imports, clean, and prepare phosphoproteomic
#' data for NetworKIN and IV-KEA.
#' @param phospho_file `<.xlsx or .csv file>` Raw phosphoproteomic data
#' @param species `<character>` Species code from which samples were obtained (`hsa` or `mmu`).
#' @param phosphosites_column `<column_name>` Column with phosphosite names
#' @param log2_column `<column_name>` Column with log2(experiment/control) values
#' @param fdr_column `<column_name>` Column with adjusted pvalues
#' @param output_folder `<character>` Where the output files should be stored (with a `/` at the end)
#' @import dplyr
#' @import readr
#' @import readxl
#' @import tidyr
#' @import stringr
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @export
#'

phospho_input <- function(phospho_file = 'phospho_human.xlsx',
                            species = 'hsa',
                            phosphosites_column = 'PhosphoSite',
                            log2_column = 'Log2',
                            fdr_column = 'Adj. Pvalue',
                            output_folder = 'myexperiment/'){
  phosphosites_column <- enquo(phosphosites_column)
  log2_column <- enquo(log2_column)
  fdr_column <- enquo(fdr_column)
  if (str_detect(phospho_file, pattern = "\\.xlsx") == TRUE ) {
    phospho <- read_xlsx(phospho_file)
  } else if (str_detect(phospho_file, pattern = "\\.csv") == TRUE) {
    phospho <- read_csv(phospho_file)
  } else {stop(paste0(sapply(str_split(phospho_file, "/"), tail, 1),
                      ' is not a .csv or a .xlsx file.'))} #Error message if data is not in a proper format
  
  phospho %<>%
    select("ProteinID-Phospho:Site" = !!phosphosites_column,
           "Log2" = !!log2_column,
           "adj_pvalue" = !!fdr_column) %>%
    filter(adj_pvalue != "NA")
  phospho %<>%
    mutate(Ratio = 2^Log2) %>%
    mutate(ACC_ID = str_extract(`ProteinID-Phospho:Site`, pattern = "^[:alnum:]*"),
           MOD_RSD = str_extract(`ProteinID-Phospho:Site`, pattern = "(?<=Phospho:).*")) %>%
    separate_rows(MOD_RSD, sep = "\\.") %>%
    mutate(MOD_RSD = paste0(MOD_RSD, "-p")) #-p added for nomenclature consistency

  if (species == 'mmu') {
    phospho <- data_humanization(phospho_df = phospho, output_folder = output_folder)
  }

  phospho %<>%
    select("substrate" = ACC_ID, MOD_RSD, Ratio, Log2, adj_pvalue)

  if (species == 'hsa') { #data humanization directly produce Uniprot IDs. This step is skipped for mouse data.
    ortho <- suppressWarnings(read_csv('https://onedrive.live.com/download?cid=38F5374142AA4416&resid=38F5374142AA4416%213701&authkey=ABuyMfUDcdV8vdo', col_types = c("__c___c"))) %>% #import Uniprot IDs
      distinct()
    phospho <- inner_join(phospho, ortho, by = c("substrate" = "PROTEIN_human")) %>%
      select("substrate" = ACC_ID_human, MOD_RSD, Ratio, Log2, adj_pvalue)
  }

  write_csv(phospho, paste0(output_folder, "phospho_clean.csv")) #write cleaned file

  phospho %>% #generate NetworKIN input
    mutate(location = str_extract(MOD_RSD, pattern = "[:digit:]+"),
           amino_acid = str_extract(MOD_RSD, pattern = "^[:alpha:]")) %>%
    select(substrate, location, amino_acid) %>%
    write_tsv(paste0(output_folder, "networKIN_input.res"), col_names = FALSE)
}
