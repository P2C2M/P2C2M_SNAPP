### Function for comparing tree distances to assess significance ###

compare.distances <- function(dists, distrib){ # dists = distances between posterior tree and random simulated posterior trees; distrib = distribution of distances between randomly drawn simulated posterior trees

  quant <- stats::quantile(distrib, probs = c(0.95)) # get value separating upper 5% of distribution (use one tail because small distance values are good)
  bad <- sum(length(which(dists > quant))) # sum the number of ditances outside of 95% distribution

  return(bad)
}
