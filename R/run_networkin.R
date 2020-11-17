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
#' @export
#' 

run_networkin <- function(input_file = 'phospho_clean.csv', 
                          output_folder = 'myexperiment/'){
  phospho <- readr::read_csv(paste0(output_folder, input_file), col_names = TRUE) %>% 
    mutate(MOD_RSD = stringr::str_extract(MOD_RSD, ".+(?=-p)"))
  predictions_networkin_nov2020 <- phosphogodb::predictions_networkin_nov2020
  predictions <- phospho %>% dplyr::inner_join(predictions_networkin_nov2020, by = c("substrate" = "#Name", "MOD_RSD" = "Position")) %>%
    dplyr::select(-Ratio, -Log2, -adj_pvalue)
  readr::write_tsv(predictions, paste0(output_folder, 'networKIN_output.tsv'))
}
