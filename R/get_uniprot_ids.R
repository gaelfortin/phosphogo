#' get_uniprot_ids
#' This function outputs a dataframe of UniprotKB accession IDs
#' and UniprotKB entry names. The dataframe is sliced to submit a
#' precise number of IDs per request (to avoid too long URLs).
#' UniprotKB entry names are submitted as a UniprotKB search to access
#' the corresponding UniprotKB IDs.
#' @param uniprot_names `<vector>` UniprotKB names
#' @param query_length `<integer>` The number of IDs to submit in once.
#' Change this parameter only if a HTTP404 error is outputted.
#' @import tibble
#' @import dplyr
#' @importFrom magrittr "%>%" 
#' @importFrom magrittr "%<>%" 
#' @export


get_uniprot_ids <- function(uniprot_names, query_length = 750){
  portions <- length(uniprot_names) %/% query_length
  uniprot_ids <- tibble("uniprot_entry_name" = character(), "ACC_ID_human" = character())

  if(portions == 0){ #data slicing useless if there are few accession IDs
    query_names <- uniprot_names
    uniprot_sites <- .get_uniprot_name(query_names)
    uniprot_ids %<>% bind_rows(uniprot_sites)
  }else{
    for(i in 1:portions){
      min = query_length*i-query_length+1
      max = query_length*i
      query_names <-  uniprot_names[min:max]
      uniprot_sites <- .get_uniprot_id(query_names)
      uniprot_entry_names %<>% bind_rows(uniprot_sites)
    }
    query_names <- uniprot_names[(portions*query_length+1):length(uniprot_names)]
    uniprot_sites <- .get_uniprot_id(query_names)
    uniprot_entry_names %<>% bind_rows(uniprot_sites)
  }
  return(uniprot_ids)
}


#' get_uniprot_id
#' This functions outputs a dataframe containing
#' the queried UniprotKB names and its corresponding
#' UniprotKB accession IDs.
#' @param query_names `<vector>`
#' @import readr
#' @import dplyr
#' @export

get_uniprot_id <- function(query_names){
  uri <- 'http://www.uniprot.org/uniprot/?query='
  idStr <- paste(query_names, collapse="+or+")
  format <- '&format=tab'
  fullUri <- paste0(uri,idStr,format)
  dat <- read_delim(fullUri, delim = "\t") %>%
    select("ACC_ID" = Entry, "uniprot_name" =  `Entry name`) %>%
    filter(uniprot_entry_name %in% query_names)
  return(dat)
}
