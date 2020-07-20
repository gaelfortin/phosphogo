#' uniprot_entry_names
#' This function outputs a dataframe of UniprotKB accession IDs
#' and UniprotKB entry names. The dataframe is sliced to submit a
#' precise number of IDs per request (to avoid too long URLs).
#' Accession IDs are submitted as a UniprotKB search. 
#' @param accession_ids `<vector>` UniprotKB accession IDS
#' @param query_length `<integer>` The number of IDs to submit in once.
#' Change this parameter only if a HTTP404 error is outputted.
#' @export


uniprot_entry_names <- function(accession_ids, query_length = 750){
  portions <- length(accession_ids) %/% query_length
  uniprot_entry_names <- tibble("ACC_ID_human" = character(), "uniprot_entry_name" = character())
  
  if(portions == 0){ #data slicing useless if there are few accession IDs
    query_ids <- accession_ids
    uniprot_sites <- .get_uniprot_name(query_ids)
    uniprot_entry_names %<>% bind_rows(uniprot_sites)
  }else{
    for(i in 1:portions){
      min = query_length*i-query_length+1
      max = query_length*i
      query_ids <-  accession_ids[min:max]
      uniprot_sites <- .get_uniprot_name(query_ids)
      uniprot_entry_names %<>% bind_rows(uniprot_sites)
    }
    query_ids <- accession_ids[(portions*query_length+1):length(accession_ids)]
    uniprot_sites <- .get_uniprot_name(query_ids)
    uniprot_entry_names %<>% bind_rows(uniprot_sites)
  }
  return(uniprot_entry_names)
}


#' get_uniprot_name 
#' This functions outputs a dataframe containing 
#' the queried UniprotKB accession IDs and its corresponding
#' UniprotKB entry names.
#' @param accession_ids `<vector>` 
#' @export

.get_uniprot_name <- function(accession_ids){
  uri <- 'http://www.uniprot.org/uniprot/?query='
  idStr <- paste(accession_ids, collapse="+or+")
  format <- '&format=tab'
  fullUri <- paste0(uri,idStr,format)
  dat <- read_delim(fullUri, delim = "\t") %>%
    select("ACC_ID_human" = Entry, "uniprot_entry_name" =  `Entry name`) %>%
    filter(ACC_ID_human %in% accession_ids)
  return(dat)
}