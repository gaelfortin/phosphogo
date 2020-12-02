#' Data dependency analysis
#' 
#' Fetch raw dependency data for a given set of kinase-cell lineage combination. Useful for visualization
#' and to identify dependent proteins targeted by tested kinases.
#' @param dependency_kinases_output `<dataframe>` Output table of the dependency_kinases function
#' @param functional_threshold `<integer>` Minimum threshold to filter functional 
#' phosphosites as defined by Ochoa et al., 2019 (0 is a not functional site, 1 a highly functional site)
#' @import depmap
#' @import ExperimentHub
#' @import ggridges 
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @export
#' 

dependency_data <- function(dependency_kinases_output, functional_threshold = 0.25){
  invitrodb <- phosphogodb::invitrodb %>% 
    mutate(uniprot_name = str_extract(uniprot_name, ".+(?=_HUMAN)"),
           position = as.numeric(str_extract(substrate_position, "[:digit:]+")))
  functional_scores <- phosphogodb::phospho_functional_scores
  func_invitrodb <- invitrodb %>% 
    inner_join(functional_scores, by = c("ACC_ID"="uniprot", "position"))  %>% 
    filter(functional_score > functional_threshold) # threshold from Ochoa et al 2019
  eh <- ExperimentHub()
  rnai <- eh[["EH3080"]]
  metadata <- eh[["EH3086"]]
  meta_rnai <- metadata %>%
    dplyr::select(depmap_id, lineage) %>%
    dplyr::full_join(rnai, by = "depmap_id")
  data <- tibble(.rows=NULL)
  for (combination in 1:nrow(dependency_kinases_output)){
    tmp_kinase <- as.character(dependency_kinases_output[combination, 3])
    tmp_lineage <- as.character(dependency_kinases_output[combination, 1])
    substrates <- func_invitrodb %>%
      filter(kinase == tmp_kinase) %>% 
      pull(uniprot_name)
    data <-  meta_rnai %>%
      filter(gene_name %in% substrates) %>% 
      filter(lineage == tmp_lineage) %>% 
      bind_cols("combination" = paste0(tmp_kinase, " for ", tmp_lineage)) %>% 
      bind_rows(data, .)
  }
  return(data)
}