### Function for calculating tree distances between posterior and posterior predictive trees ###

calc.distances <- function(trees, post_samples, pops, dist_reps, save_graphs){

  tree_files <- Sys.glob("*.trees") # get simulated tree files
  tree_files <- tree_files[which(tree_files != "snap.trees")] # remove empirical treefile from list

  sim_trees <- suppressWarnings(lapply(tree_files, function(x) simtree.reader(x, pops))) # read in simulated treefiles
  sim_length <- length(sim_trees[[1]])
  sim_trees <- lapply(lapply(seq(1, length(sim_trees), 1), function(x) sim_trees[x]), function(x) ape::read.tree(text = unlist(x))) # create list of simulated trees by reading into ape

  #tree_distributions_kf <- list()
  tree_distributions_rf <- list()
  #tree_distances_kf <- list()
  tree_distances_rf <- list()
  for (i in 1:length(sim_trees)){
    print(i)
    tree1 <- sample(seq(1, sim_length, 1), 1000, replace = TRUE) # create random indices for 1st tree to compare
    tree2 <- sample(seq(1, sim_length, 1), 1000, replace = TRUE) # create random indices for 2nd tree to compare

    #distribution_kf <- list(mapply(function(x,y) dist.topo(sim_trees[[i]][x], sim_trees[[i]][y], "score"), tree1, tree2)) # calculate distance distributions for simulated posterior
    suppressWarnings(distribution_rf <- list(mapply(function(x,y) ape::dist.topo(sim_trees[[i]][x], sim_trees[[i]][y], "PH85"), tree1, tree2))) # calculate distance distributions for simulated posterior

    #tree_distributions_kf <- append(tree_distributions_kf, distribution_kf, after = length(tree_distributions_kf))
    tree_distributions_rf <- append(tree_distributions_rf, distribution_rf, after = length(tree_distributions_rf))

    snapp_tree <- trees[[i]] # get posterior tree
    rand_tree <- sample(sim_trees[[i]], size = dist_reps, replace = FALSE) # get random trees to test posterior tree against

    # Kuhner-Felsenstein (incorporates branch lengths)
    #distances_kf <- paste0(lapply(rand_tree, function(x) dist.topo(x, snapp_tree, "score"))) # calculate distances between posterior tree and random trees
    #distances_kf <- lapply(distances_kf, function(x) as.numeric(x))
    #tree_distances_kf <- append(tree_distances_kf, list(distances_kf), after = length(tree_distances_kf))

    # Robinson-Foulds (topology only)
    suppressWarnings(distances_rf <- suppressWarnings(paste0(lapply(rand_tree, function(x) ape::dist.topo(x, snapp_tree, "PH85"))))) # calculate distances between posterior tree and random trees
    distances_rf <- lapply(distances_rf, function(x) as.numeric(x))
    tree_distances_rf <- append(tree_distances_rf, list(distances_rf), after = length(tree_distances_rf))

  }


  #violations_kf <- mapply(function(x, y) compare.distances(unlist(x), unlist(y)), tree_distances_kf, tree_distributions_kf) # compare distances for all trees drawn from posterior
  #p_violations_kf <- sum(violations_kf) / (dist_reps * length(post_samples)) # calculate percentage of all trees that fall outside 95% distribution

  violations_rf <- mapply(function(x, y) compare.distances(unlist(x), unlist(y)), tree_distances_rf, tree_distributions_rf) # compare distances for all trees drawn from posterior
  p_violations_rf <- sum(violations_rf) / (dist_reps * length(post_samples)) # calculate percentage of all trees that fall outside 95% distribution

  ### Create histograms ###
  if (save_graphs == TRUE){
    #hist.writer("Kuhner-Felsenstein Distance", tree_distances_kf, tree_distributions_kf)
    hist.writer("Robinson-Foulds Distance", tree_distances_rf, tree_distributions_rf)
    #hist.writer("KF", tree_distances_kf, unlist(tree_distances_kf))
  }

  return(list(p_violations_rf))
}





