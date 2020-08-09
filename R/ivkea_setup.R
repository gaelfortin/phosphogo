#' IV-KEA setup
#' This function installs the in vitro database from Sugiyama et al. 2019.
#' It downloads all UniprotKB accession IDs that are required for IV-KEA.
#' This function is not part of the main pipeline as the projet already includes
#' a ready-to-use in vitro database.
#' @param invitrodb_file `<character>` Location of the in vitro database
#' from Sugiyama 2019.
#' @import readxl
#' @import dplyr
#' @import readr
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @export

ivkea_setup <- function(invitrodb_file = 'data/imported/raw_db_phosphosite_kinase_invitro.xlsx'){
  invitro_db <- read_xlsx(invitrodb_file, col_names = FALSE, skip = 2)
  colnames(invitro_db) <- c("type", "kinase", "uniprot_name", "substrate_protein_description", "substrate_position", "sidic_confirmation", "PTMscore_confirmation")
  invitro_db %<>%
    mutate(sidic_confirmation = if_else(is.na(sidic_confirmation) == FALSE, "yes", "no"),
           PTMscore_confirmation = if_else(is.na(PTMscore_confirmation) == FALSE, "yes", "no"))
  source('R/get_uniprot_ids.R')
  uniprot_ids <- get_uniprot_ids(unique(invitro_db$substrate_uniprot_name), query_length = 400)
  invitro_db %<>% left_join(uniprot_ids, by = "uniprot_name")
  write_csv(invitro_db, 'data/imported/invitrodb.csv')
}

