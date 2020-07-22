#' Run NetworKIN
#' This function prepares and executes NetworKIN to generate predictions
#' on a given set of phosphorylated peptides.
#' NetworKIN requires Python and the BLASTALL version of BLAST.
#' @param input_file `<character>` Location of the input file 
#' @param blastall_location `<character>` Location of BLASTALL on the computer
#' @param experiment `<character>` Name of the experiment to tag output
#' @export
#' 

run_networkin <- function(input_file = 'data/outputs/networKIN_input_test.res', 
                          blastall_location, 
                          experiment = 'test'){
  dir.create("tmp", showWarnings = FALSE) #create a temporary folder for NetworKIN
  Sys.setenv(TMPDIR = "tmp")
  system(paste0("networkin/bin/NetworKIN3.0_release/NetworKIN.py -n   networkin/bin/NetPhorest_human_2.1/netphorest -b ", 
                blastall_location, 
                " 9606 networkin/databases/uniprot122013/cleaned_9606_uniprot_201312.fa ", 
                input_file, 
                " > data/outputs/networKIN_output_", 
                experiment, 
                ".tsv")) #Run NetworKIN
}