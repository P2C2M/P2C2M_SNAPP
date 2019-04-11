##### Randomly sample from posterior #####

draw.samples <- function(num_sims, gens_run){ # num.sims = user input # of simulations to perform; gens_run = # of markov steps saved
  
  burnin <- ceiling(gens_run * 0.10)
  non_burnin <- seq(burnin, gens_run, 1) # get sequence of step numbers in non burnin posterior
  
  if (num_sims > length(non_burnin)){ # if # of simulations input is greater than the number of steps in the posterior
    post_samples <- non_burnin # use all non_burnin steps
  } else{
    post_samples <- sort(sample(non_burnin, num_sims)) # randomly sample steps
  }
  
  return(post_samples)
}
