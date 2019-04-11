### Function for calculating summary statistics and assessing their significance ###

sum.stats <- function(xml_file, trees, post_samples, pops, dist_reps){ # post_samples = samples drawn from posterior; pops = number of populations; dist_reps = # of trees from simulated posterior to calculate distance against posterior tree
  
  stats <- list()
  
  cat("Calculating and comparing tree distances\n\n")
  p_distances <- calc.distances(trees, post_samples, pops, dist_reps)
  stats$p_kf <- p_distances[[1]]
  stats$p_rf <- p_distances[[2]]
  
  cat("Comparing likelihoods\n\n")
  p_ml <- calc.likelihoods(post_samples)
  stats$p_mlm <- p_ml[[1]]
  stats$p_mlsd <- p_ml[[2]]
  
  cat("Calculating and comparing Fsts\n\n")
  p_fst <- calc.fst(xml_file)
  stats$p_fst_average <- p_fst[[1]]
  stats$p_fst_range <- p_fst[[2]]
  stats$pair_fst_viols <- p_fst[[3]]
  
  return(stats)
  
}
