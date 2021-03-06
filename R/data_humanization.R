#' Humanize phosphoproteomic data
#' 
#' This function humanizes mouse phosphoproteomic data according to the
#' PhosphoSitePlus orthology database.
#' @param phospho_df `<dataframe>` Dataframe to humanize
#' @param output_folder `<character>` Where the output files should be stored
#' @import readr
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @importFrom rlang .data
#' @export
#'

data_humanization <- function(phospho_df = phospho,
                              output_folder = 'myexperiment/'){
  phospho <- NULL
  ortho <- phosphogodb::ortho
  phospho_df <-
    inner_join(phospho_df,
               ortho,
               by = c("ACC_ID" = "ACC_ID_mouse", "MOD_RSD" = "MOD_RSD_mouse"))
  phospho_df %<>%
    mutate(`ProteinID-Phospho:Site` = paste0(.data$ACC_ID_human, "-Phospho:", str_extract(.data$MOD_RSD_human, "[:alnum:]+"))) %>%
    select(.data$`ProteinID-Phospho:Site`, .data$Log2, .data$adj_pvalue, .data$Ratio, "ACC_ID" = .data$ACC_ID_human, "MOD_RSD" = .data$MOD_RSD_human)
  return(phospho_df)
}
