% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fisher_exact_test.R
\name{fisher_exact_test}
\alias{fisher_exact_test}
\title{Fisher exact test}
\usage{
fisher_exact_test(na, nb, tota, totb)
}
\arguments{
\item{na}{\verb{<integer>} value for the tested item in group A}

\item{nb}{\verb{<integer>} value for the tested item in group B}

\item{tota}{\verb{<integer>} total number of items in group A}

\item{totb}{\verb{<integer>} total number of items in group B}
}
\description{
Computes the odds ratio and its pvalue of Fisher enrichment exact test.
}
