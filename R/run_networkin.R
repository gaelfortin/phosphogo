#' Run NetworKIN
#' 
#' This function prepares and executes NetworKIN to generate predictions
#' on a given set of phosphorylated peptides.
#' NetworKIN requires Python and the BLASTALL version of BLAST.
#' @param input_file `<character>` Location of the input file 
#' @param blastall_location `<character>` Location of BLASTALL on the computer
#' @param output_folder `<character>` Where the output files should be stored
#' @export
#' 

run_networkin <- function(input_file = 'networKIN_input.res', 
                          blastall_location, 
                          output_folder = 'data/'){
  if (file.exists(blastall_location)==FALSE) {
    stop('BLASTALL was not found on your device. Follow phosphogo documentation to know how to install BLASTALL on your device.')
  }
  dir.create("tmp", showWarnings = FALSE) #create a temporary folder for NetworKIN
  Sys.setenv(TMPDIR = "tmp")
  system(paste0("networkin/bin/NetworKIN3.0_release/NetworKIN.py -n   networkin/bin/NetPhorest_human_2.1/netphorest -b ", 
                blastall_location, 
                " 9606 networkin/databases/uniprot122013/cleaned_9606_uniprot_201312.fa ", 
                output_folder, input_file, 
                " > ", output_folder, "networKIN_output.tsv")) #Run NetworKIN
}
