#' Fisher exact test
#' 
#' Computes the odds ratio and its pvalue of Fisher enrichment exact test.
#' @param na `<integer>` value for the tested item in group A
#' @param nb `<integer>` value for the tested item in group B
#' @param tota `<integer>` total number of items in group A
#' @param totb `<integer>` total number of items in group B
#' @importFrom stats fisher.test
#' @importFrom stats p.adjust
#' @export
#' 
fisher_exact_test <- function(na, nb, tota, totb){
  matrix_to_test <- matrix(c(na, tota-na, nb, totb-nb), nrow = 2)
  fisher_res <- fisher.test(matrix_to_test)
  pvalue <-  as.numeric(fisher_res$p.value)
  odds_ratio <- as.numeric(fisher_res$estimate)
  merged <- paste(pvalue, odds_ratio, sep=",")
  return(merged)
}