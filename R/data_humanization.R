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
#' @export
#'

data_humanization <- function(phospho_df = phospho,
                              output_folder = 'myexperiment/'){
  ortho <- read_csv('https://onedrive.live.com/download?cid=38F5374142AA4416&resid=38F5374142AA4416%213701&authkey=ABuyMfUDcdV8vdo', col_types = cols())
  phospho_df <-
    inner_join(phospho_df,
               ortho,
               by = c("ACC_ID" = "ACC_ID_mouse", "MOD_RSD" = "MOD_RSD_mouse"))
  phospho_df %<>%
    mutate(`ProteinID-Phospho:Site` = paste0(ACC_ID_human, "-Phospho:", str_extract(MOD_RSD_human, "[:alnum:]+"))) %>%
    select(`ProteinID-Phospho:Site`, Log2, adj_pvalue, Ratio, "ACC_ID" = ACC_ID_human, "MOD_RSD" = MOD_RSD_human)
  return(phospho_df)
}
