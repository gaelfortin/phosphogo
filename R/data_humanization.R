#' Humanize phosphoproteomic data
#' This function humanizes mouse phosphoproteomic data according to the
#' PhosphoSitePlus orthology database.
#' @param phospho_df `<dataframe>` Dataframe to humanize
#' @param experiment `<character>` Name of the experiment to tag output files
#' @import readr
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @export
#'

data_humanization <- function(phospho_df = phospho,
                              experiment = 'test'){
  ortho <- read_csv("data/imported/shared_phospho_human_mouse.csv", col_types = cols())
  phospho_df <-
    inner_join(phospho_df,
               ortho,
               by = c("ACC_ID" = "ACC_ID_mouse", "MOD_RSD" = "MOD_RSD_mouse"))
  phospho_df %<>%
    mutate(`ProteinID-Phospho:Site` = paste0(ACC_ID_human, "-Phospho:", str_extract(MOD_RSD_human, "[:alnum:]+"))) %>%
    select(`ProteinID-Phospho:Site`, Log2, adj_pvalue, Ratio, "ACC_ID" = ACC_ID_human, "MOD_RSD" = MOD_RSD_human)
  return(phospho_df)
}
