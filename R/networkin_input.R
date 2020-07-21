#' Generate NetworKIN input
#' This function imports, clean, and prepare phosphoproteomic 
#' data for NetworKIN.
#' @param phospho_file `<.xlsx file>` Raw phosphoproteomic data
#' @param phosphosites_column `<column_name>` Column with phosphosite names
#' @param log2_column `<column_name>` Column with log2(experiment/control) values
#' @param fdr_column `<column_name>` Column with adjusted pvalues
#' @param experiment `<column_name>` Name of the experiment to tag output files
#' @export
#' 

networkin_input <- function(phospho_file = 'data/imported/phospho.xlsx',
                            phosphosites_column = 'ProteinID-Phospho:Site',
                            log2_column = 'Log2(Relapse/diagnostic)',
                            fdr_column = 'Adj. pvalue',
                            experiment = 'test'){
  require(tidyverse)
  require(magrittr)
  phosphosites_column <- enquo(phosphosites_column)
  log2_column <- enquo(log2_column)
  fdr_column <- enquo(fdr_column)
  proteo <- readxl::read_xlsx(phospho_file)
  proteo %<>% 
    select("ProteinID-Phospho:Site" = !!phosphosites_column,
           "Log2" = !!log2_column,
           "ajd_pvalue" = !!fdr_column) %>% 
    filter(ajd_pvalue != "NA")
  proteo %<>% 
    mutate(Ratio = 2^Log2) %>% 
    mutate(ACC_ID = str_extract(`ProteinID-Phospho:Site`, pattern = "^[:alnum:]*"),
           MOD_RSD = str_extract(`ProteinID-Phospho:Site`, pattern = "(?<=Phospho:).*")) %>% 
    tidyr::separate_rows(MOD_RSD, sep = "\\.") %>% 
    mutate(MOD_RSD = paste0(MOD_RSD, "-p")) #-p added for nomenclature consistency
  proteo %<>% 
    select("substrate" = ACC_ID, MOD_RSD) %>% 
    mutate(location = str_extract(MOD_RSD, pattern = "[:digit:]+"),
           amino_acid = str_extract(MOD_RSD, pattern = "^[:alpha:]")) %>% 
    select(-MOD_RSD)
  ortho <- read_csv("data/imported/shared_phospho_human_mouse.csv", col_types = c("__c___c")) %>% #import Uniprot IDs
    distinct()
  proteo <- inner_join(proteo, ortho, by = c("substrate" = "PROTEIN_human")) %>% 
    write_csv(paste0("data/outputs/phospho_clean_", experiment, ".csv")) #write cleaned file
  proteo %>% #generate NetworKIN input
    select(ACC_ID_human, location, amino_acid) %>% 
    write_tsv(paste0("data/outputs/networKIN_input_", experiment ,".res"), col_names = FALSE)
}