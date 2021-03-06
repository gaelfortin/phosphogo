% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/perform_fisher_exact_test.R
\name{perform_Fisher_exact_test}
\alias{perform_Fisher_exact_test}
\title{Perform Fisher exact test}
\usage{
perform_Fisher_exact_test(
  predictions_file = "networkin_output.csv",
  predictions = "networkin",
  output_folder = "myexperiment/",
  FC_threshold = 1.2
)
}
\arguments{
\item{predictions_file}{\verb{<character>} Location of the file with top predictions per phosphosite}

\item{predictions}{\verb{<character>} The algorithm used for predictions (NetworKIN or IV-KEA)}

\item{output_folder}{\verb{<character>} Where the output files should be stored}

\item{FC_threshold}{\verb{<numeric>} Fold change threshold to select phosphosites.}
}
\description{
This function computes Fisher exact test and the corresponding adjusted p-values (FDR)
for upregulated vs downregulated phosphosites, upregulated vs all phosphosites,
downregulated vs all phosphosites.
}
