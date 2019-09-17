#' \code{P2C2M.SNAPP} An R package for conducting posterior predictive checks of SNAPP analyses.
#'
#' P2C2M.SNAPP contains a single function that uses output from SNAPP phylogenetic analyses software to simulate posterior predictive datasets and uses those datasets to identify violations to the Multispecies Coalescent Model implemented in SNAPP.
#'
#' A tutorial with example files is included with the package, as well as an example script for snalyzing posterior predictive datasets with SNAPP.
#'
#' @docType package
#' @name P2C2M.SNAPP
#' @examples
#' \donttest{
#' run.p2c2m.snapp(path_to_xml = tempdir(), xml_file = "snapp.xml",
#'                 sum_stat = c("RF", "MLSD", "PFST"), num_sims = 100, dist_reps = 100,
#'                 sample_unif = TRUE, delete_sims = FALSE, save_graphs = TRUE,
#'                 save_output = TRUE, run_mode = 1)
#' run.p2c2m.snapp(path_to_xml = tempdir(), xml_file = "snapp.xml",
#'                 sum_stat = c("RF", "MLSD", "PFST"), num_sims = 100, dist_reps = 100,
#'                 sample_unif = TRUE, delete_sims = FALSE, save_graphs = TRUE,
#'                 save_output = TRUE, run_mode = 2)
#' }
NULL
