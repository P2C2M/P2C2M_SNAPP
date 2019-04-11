### Function for comparing marginal likelihoods between posterior and posterior predictive trees ###

compare.likelihoods <- function(post_like, sim_likes){ # post_like = likelihood value of posterior tree; sim_likes = distribution of likelihood values from simulated posterior
  
  quant_like <- quantile(sim_likes, probs = c(0.025, 0.975)) # calculate 95% distribution values from simulated likelihoods
  
  if (post_like < quant_like[1] | post_like > quant_like[2]){ # if empirical likelihood falls outside 95% simulated likelihoods
    val <- 1
  } else{
    val <- 0
  }
  
  return(val)
}
