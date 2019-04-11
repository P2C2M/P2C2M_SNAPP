### Function for obtaining marginal likelihoods from posterior and posterior predictive trees ###

calc.likelihoods <- function(post_samples){ 
  
  snap_table <- read.table("snap.log", header = TRUE) # read in likelihood table for empirical snapp run
  logs <- Sys.glob("*.log") # get simulated log files
  logs <- logs[which(logs != "snap.log")]
  log_tables <- lapply(logs, function(x) read.table(x, header = TRUE)) # read in simulated likelihood tables
  like_logs <- lapply(log_tables, function(x) x$likelihood) # create list of lists of likelihood values
  
  
  emp_mean <- mean(snap_table$likelihood[unlist(post_samples)]) # calculate posterior mean
  sim_means <- lapply(like_logs, function(x) mean(unlist(x))) # calculate mean for each simulated posterior
  mean_upper <- length(which(unlist(sim_means) >= emp_mean)) # calculate how many simulated values are >= empirical value
  mean_lower <- length(which(unlist(sim_means) <= emp_mean)) # calculate how many simulated values are <= empirical value
  p_violations_like_mean <- min(c(mean_upper, mean_lower)) * 2 / length(sim_means) # treat as two-tailed test 
  
  
  #violations_like <- mapply(function(x, y) compare.likelihoods(unlist(x), unlist(y)), snap_table$likelihood[unlist(post_samples)], like_logs) # compare likelihoods for all trees drawn from posterior
  #p_violations_like <- sum(violations_like) / length(post_samples) # calculate percentage of trees that fall outside of 95% distribution
  
  post_likes <- snap_table[rep(seq_len(nrow(snap_table)), each = 100),] # replicate empirical SNAPP values to get some number of values as simulations
  difference_like <- post_likes$likelihood - unlist(like_logs) # subtract simulated from empirical values
  
  emp_sd <- sd(snap_table$likelihood) 
  pred_sd <- lapply(like_logs, sd)
  upper <- length(which(unlist(pred_sd) >= emp_sd)) # calculate how many simulated values are >= empirical value
  lower <- length(which(unlist(pred_sd) <= emp_sd)) # calculate how many simulated values are <= empirical value
  p_violations_like_sd <- min(c(upper,lower)) * 2 /length(pred_sd) # treat as two-tailed test
  
  ### Create histogram ###
  #hist.writer("Marginal Likelihood", snap_table$likelihood[unlist(post_samples)], like_logs)
  hist.writer("Likelihood Mean", emp_mean, unlist(sim_means))
  hist.writer("Likelihood SD", emp_sd, unlist(pred_sd))
  
  results_like <- list(p_violations_like_mean, p_violations_like_sd)
  return(results_like)
}
