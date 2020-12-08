#' Kinases dependency analysis
#' 
#' Computes the dependency score of the given list of kinases using DepMap RNAi data.
#' @param kinases `<vector>` Vector of kinases to analyze
#' @param dependency_threshold `<integer>` Minimum dependency score to consider 
#' (0 is a non-essentiel gene, 1 an essential gene)
#' @param functional_threshold `<integer>` Minimum threshold to filter functional 
#' phosphosites as defined by Ochoa et al., 2019 (0 is a not functional site, 1 a highly functional site)
#' @param output_folder `<character>` Where the output files should be stored
#' @import depmap
#' @import ExperimentHub
#' @import ggridges 
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @export
#' 


dependency_kinases <- function(kinases, dependency_threshold = -0.2, functional_threshold = 0.25, output_folder = 'myexperiment/'){
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
  dependencies <- tibble(.rows = NULL)
  for (k in kinases){
    substrates <- func_invitrodb %>%
      filter(kinase == k) %>% 
      pull(uniprot_name)
    dependencies <-  meta_rnai %>%
      filter(gene_name %in% substrates) %>% 
      group_by(lineage) %>% 
      summarise(median_dependency = median(dependency, na.rm = TRUE)) %>% 
      filter(!is.na(lineage)) %>% 
      bind_cols("kinase" = k) %>% 
      bind_rows(dependencies, .)
  }
  filter(dependencies, median_dependency < dependency_threshold) %>%
    write_csv(paste0(output_folder, "dependency_kinases.csv"))
  return(filter(dependencies, median_dependency < dependency_threshold))
}
