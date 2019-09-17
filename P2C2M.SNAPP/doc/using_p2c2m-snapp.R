## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval = FALSE--------------------------------------------------------
#  install.packages("path/to/P2C2M.SNAPP_1.0.0.tar.gz", repos = NULL, type = "source")

## ----eval = FALSE--------------------------------------------------------
#  if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#  
#  BiocManager::install("ggtree")

## ----eval = FALSE--------------------------------------------------------
#  run.p2c2m.snapp(path_to_xml = tempdir(), xml_file = "snapp.xml",
#                  sum_stat = c("RF", "MLSD", "PFST"), num_sims = 100, dist_reps = 100,
#                  sample_unif = TRUE, delete_sims = FALSE, save_graphs = TRUE,
#                  save_output = TRUE, run_mode = 1)

## ----eval = FALSE--------------------------------------------------------
#  run.p2c2m.snapp(path_to_xml = tempdir(), xml_file = "snapp.xml",
#                  sum_stat = c("RF", "MLSD", "PFST"), num_sims = 10, dist_reps = 100,
#                  sample_unif = TRUE, delete_sims = FALSE, save_graphs = TRUE,
#                  save_output = TRUE, run_mode = 1)

## ----eval = FALSE--------------------------------------------------------
#  run.p2c2m.snapp(path_to_xml = tempdir(), xml_file = "snapp.xml",
#                  sum_stat = c("RF", "MLSD", "PFST"), num_sims = 10, dist_reps = 100,
#                  sample_unif = TRUE, delete_sims = FALSE, save_graphs = TRUE,
#                  save_output = TRUE, run_mode = 2)

## ----eval = FALSE--------------------------------------------------------
#  P2C2M Completed
#  
#                 Stat   p
#  p_rf           "RF"   0
#  p_mlsd         "MLSD" 0
#  pair_fst_viols "PFST" "None"
#  Comparisons likely to violate model:
#   None
#  

