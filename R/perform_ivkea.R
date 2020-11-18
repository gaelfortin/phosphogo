#' Perform IV-KEA
#' This function performs IV-KEA on a given phosphoproteomic file
#' according to the in vitro database produced by Sugiyama et al. 2019.
#' @param clean_phospho_file `<character>` Location of the clean
#' phosphoproteomic file
#' @param output_folder `<character>` Where the output files should be stored
#' @import readr
#' @import dplyr
#' @importFrom tidyr everything
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%"
#' @importFrom rlang .data 
#' @export

perform_ivkea <- function(clean_phospho_file = 'phospho_clean.csv',
                          output_folder = 'myexperiment/'
                          ){
  phospho <- read_csv(paste0(output_folder, clean_phospho_file), col_types = cols())
  invitrodb <- phosphogodb::invitrodb
  invitro_db <- invitrodb %>% 
    mutate(substrate_position = paste0(.data$substrate_position, "-p"))
  invitro_phospho_predictions <- phospho %>%
    left_join(invitro_db, by = c("substrate" = "ACC_ID", "MOD_RSD" = "substrate_position")) %>%
    select(everything(), -.data$substrate_protein_description, 'top_predicted_kinase' = .data$kinase)
  write_csv(invitro_phospho_predictions, paste0(output_folder, "ivkea_predictions.csv"))

}

