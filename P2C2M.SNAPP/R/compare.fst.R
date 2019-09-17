##### Function to compare fst averages and ranges #####

compare.fst <- function(emp_fst, pred_fst){
  
  upper <- length(which(unlist(pred_fst) > emp_fst)) # calculate how many simulated values are > empirical value
  lower <- length(which(unlist(pred_fst) <= emp_fst)) # calculate how many simulated values are <= empirical value
  p_violations_fst <- min(c(upper,lower)) * 2 /length(pred_fst) # treat as two-tailed test
  
  return(p_violations_fst)
}