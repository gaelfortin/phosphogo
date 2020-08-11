#' Generate NetworKIN input
#' 
#' This function imports, clean, and prepare phosphoproteomic
#' data for NetworKIN.
#' @param phospho_file `<.xlsx file>` Raw phosphoproteomic data
#' @param species `<character>` Species code from which samples were obtained (`hsa` or `mmu`).
#' @param phosphosites_column `<column_name>` Column with phosphosite names
#' @param log2_column `<column_name>` Column with log2(experiment/control) values
#' @param fdr_column `<column_name>` Column with adjusted pvalues
#' @param experiment `<character>` Name of the experiment to tag output files
#' @import dplyr
#' @import readr
#' @import readxl
#' @import tidyr
#' @import stringr
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @export
#'

networkin_input <- function(phospho_file = 'data/imported/phospho_human.xlsx',
                            species = 'hsa',
                            phosphosites_column = 'PhosphoSite',
                            log2_column = 'Log2',
                            fdr_column = 'Adj. Pvalue',
                            experiment = 'human'){
  phosphosites_column <- enquo(phosphosites_column)
  log2_column <- enquo(log2_column)
  fdr_column <- enquo(fdr_column)
  phospho <- read_xlsx(phospho_file)
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
    phospho <- data_humanization(phospho_df = phospho, experiment = experiment)
  }

  phospho %<>%
    select("substrate" = ACC_ID, MOD_RSD, Ratio, Log2, adj_pvalue)

  if (species == 'hsa') { #data humanization directly produce Uniprot IDs. This step is skipped for mouse data.
    ortho <- read_csv("data/imported/shared_phospho_human_mouse.csv", col_types = c("__c___c")) %>% #import Uniprot IDs
      distinct()
    phospho <- inner_join(phospho, ortho, by = c("substrate" = "PROTEIN_human")) %>%
      select("substrate" = ACC_ID_human, MOD_RSD, Ratio, Log2, adj_pvalue)
  }

  write_csv(phospho, paste0("data/outputs/phospho_clean_", experiment, ".csv")) #write cleaned file

  phospho %>% #generate NetworKIN input
    mutate(location = str_extract(MOD_RSD, pattern = "[:digit:]+"),
           amino_acid = str_extract(MOD_RSD, pattern = "^[:alpha:]")) %>%
    select(substrate, location, amino_acid) %>%
    write_tsv(paste0("data/outputs/networKIN_input_", experiment ,".res"), col_names = FALSE)
}
