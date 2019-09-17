### Function for reading in simulated trees from simulated SNAPP runs ###

simtree.reader <- function(sim_treefile, pops){
  
  sim_file <- file(sim_treefile, "r")
  readLines(sim_file, n  = 10 + (2 * pops)) # skip header
  sim_lines <- readLines(sim_file) # read in trees
  close(sim_file)
  sim_lines <- sim_lines[1:length(sim_lines)-1] # remove tail line
  
  strees <- lapply(sim_lines, function(x) as.character(x))
  
  
  return(strees)
  
}