### Function for calculating summary statistics and assessing their significance ###

sum.stats <- function(xml_file, trees = NULL, post_samples, pops, dist_reps, sum_stat, save_graphs){ # post_samples = samples drawn from posterior; pops = number of populations; dist_reps = # of trees from simulated posterior to calculate distance against posterior tree; save_graphs = should histograms be written to files

  stats <- list()

  if ("RF" %in% sum_stat == TRUE){
    print("Calculating and comparing tree distances")
    p_distances <- calc.distances(trees, post_samples, pops, dist_reps, save_graphs)
    #stats$p_kf <- p_distances[[1]]
    stats$p_rf <- p_distances[[1]]
  }

  if ("MLSD" %in% sum_stat == TRUE){
    print("Comparing likelihoods")
    p_ml <- calc.likelihoods(post_samples, save_graphs)
    #stats$p_mlm <- p_ml[[1]]
    stats$p_mlsd <- p_ml[[1]]
  }

  if ("PFST" %in% sum_stat == TRUE){
    print("Calculating and comparing Fsts")
    p_fst <- calc.fst(xml_file, save_graphs)
    #stats$p_fst_average <- p_fst[[1]]
    #stats$p_fst_range <- p_fst[[2]]
    stats$pair_fst_viols <- p_fst[[1]]
  }

  return(stats)

}
