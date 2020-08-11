#' Perform IV-KEA
#' This function performs IV-KEA on a given phosphoproteomic file
#' according to the in vitro database produced by Sugiyama et al. 2019.
#' @param clean_phospho_file `<character>` Location of the clean
#' phosphoproteomic file
#' @param invitrodb_file `<character>` Location of the in vitro database.
#' This must be the ready-to-use version of the database produced by `ivkea_setup`
#' @param uniprot_id_phospho `<column_name>` Column with UniprotKB IDs in
#' the file containing cleaned phosphoproteomic results.
#' @param uniprot_id_invitrodb Column with UniprotKB IDs in the in vitro
#' database from Sugiyama 2019.
#' @param experiment `<character>` Name of the experiment to tag output
#' @import readr
#' @import dplyr
#' @importFrom tidyr everything
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @export

perform_ivkea <- function(clean_phospho_file = 'data/outputs/phospho_clean.csv',
                          invitrodb_file = 'data/imported/invitrodb.csv',
                          experiment = 'test'
                          ){
  phospho <- read_csv(clean_phospho_file, col_types = cols())
  invitro_db <- read_csv(invitrodb_file, col_types = cols()) %>% 
    mutate(substrate_position = paste0(substrate_position, "-p"))
  invitro_phospho_predictions <- phospho %>%
    left_join(invitro_db, by = c("substrate" = "ACC_ID", "MOD_RSD" = "substrate_position")) %>%
    select(everything(), -substrate_protein_description, 'top_predicted_kinase' = kinase)

  write_csv(invitro_phospho_predictions, paste0("data/outputs/ivkea_predictions_", experiment, ".csv"))

}

