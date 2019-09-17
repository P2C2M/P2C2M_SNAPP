##### Function to read in and format SNAPP trees from posterior #####

snapptree.reader <- function(treefile, post_samples, npops){ # treefile = snapp output treefile name; post_samples = line indices of trees to sample from the posterior; npops = number of pops/species
  post_samples2 <- post_samples
  post_samples3 <- c(0, post_samples2[1:length(post_samples2)-1]) + 1 # create vector to be used below
  post_samples4 <- post_samples2 - post_samples3 # subtract the two vectors to obtain a vector of values, each being the number of trees to skip

  file <- file(treefile, "r")
  snapp_trees <- c()
  
  readLines(file, (10 + 2*npops)) # skip header lines
  
  for (samp in post_samples4){
    readLines(file, n=samp) # skip lines
    snapp_trees <- c(snapp_trees, readLines(file, n=1)) # read tree
  }
  
  close(file)
  
  snapp_trees <- ape::read.tree(text = snapp_trees) # read as trees with ape
  
  return(snapp_trees)
}