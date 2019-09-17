##### Randomly sample from posterior #####

draw.samples <- function(num_sims, gens_run, sample_unif){ # num.sims = user input # of simulations to perform; gens_run = # of markov steps saved; sample_unif = if true, sample posterior uniformly. Otherwise sample randomly

  burnin <- ceiling(gens_run * 0.10)
  non_burnin <- seq(burnin + 1, gens_run, 1) # get sequence of step numbers in non burnin posterior

  if (num_sims > length(non_burnin)){ # if # of simulations input is greater than the number of steps in the posterior
    post_samples <- non_burnin # use all non_burnin steps
  } else{

    if (sample_unif == TRUE){
      interval <- length(non_burnin) / num_sims # get interval to sample
      post_samples <- non_burnin[1]

      while (post_samples[length(post_samples)] + interval <= gens_run){
        post_samples = c(post_samples, post_samples[length(post_samples)] + interval)
      }
      post_samples <- sapply(post_samples, floor) # round down

    } else{

      post_samples <- sort(sample(non_burnin, num_sims)) # randomly sample steps
    }
  }

  return(post_samples)
}


