#' Run NetworKIN
#' 
#' This function uses pre-computed NetworKIN predictions to generate predictions
#' on a given set of phosphorylated peptides.
#' @param input_file `<character>` Location of `phospho_clean` file 
#' @param output_folder `<character>` Where the output files should be stored
#' @import dplyr
#' @import readr
#' @import readxl
#' @import tidyr
#' @import stringr
#' @importFrom magrittr "%>%" 
#' @importFrom rlang .data
#' @export
#' 

run_networkin <- function(input_file = 'phospho_clean.csv', 
                          output_folder = 'myexperiment/'){
  phospho <- readr::read_csv(paste0(output_folder, input_file), col_names = TRUE) %>% 
    mutate(MOD_RSD = stringr::str_extract(.data$MOD_RSD, ".+(?=-p)"))
  predictions_networkin_nov2020 <- phosphogodb::predictions_networkin_nov2020
  predictions <- phospho %>% dplyr::inner_join(predictions_networkin_nov2020, by = c("substrate" = "#Name", "MOD_RSD" = "Position")) 
  
  predictions <-predictions %>% 
    mutate(protein_phosphosite = paste0(.data$substrate, ":", .data$MOD_RSD)) %>% 
    mutate(MOD_RSD = paste0(.data$MOD_RSD, "-p")) %>% 
    select(.data$substrate, 
           .data$MOD_RSD, 
           "target_name" =  .data$`Target description`,
           "top_predicted_kinase" = .data$`Kinase/Phosphatase/Phospho-binding domain`, 
           .data$protein_phosphosite,
           .data$Ratio,
           .data$Log2,
           .data$adj_pvalue,
           "networkin_score" = .data$`NetworKIN score`)
    write_csv(predictions, paste0(output_folder, 'networkin_output.csv'))
}
