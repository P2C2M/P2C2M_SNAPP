##### Function to assess each pairwise Fst #####

id_pairwise_fst <- function(pop_combos, empirical_fst, sim_fst_list){
  
  sim_pop_fst <- lapply(seq(1, length(empirical_fst)), function(x) sim_fst_list[x]) # create list where each entry is a pairwise Fst
  
  p_pair_fst <- mapply(function(x,y) compare.fst(x, unlist(y)), empirical_fst, sim_pop_fst) # compare empirical and simulated pairwise fsts
  
  pair_fst_diff <- list(unlist(empirical_fst) - unlist(lapply(sim_pop_fst, function(x) mean(unlist(x))))) # Calculate difference between empirical and simulated pairwise fsts
  
  pop_combo_names <- lapply(seq(1, length(empirical_fst)), function(x) paste(as.character(pop_combos[x][[1]][[1]]), as.character(pop_combos[x][[1]][[2]]), sep = "v"))
  
  grDevices::pdf(file = paste0("Pair_Differences", ".pdf")) # start pdf
  barplot(unlist(pair_fst_diff), main = "Difference in Pairwise Fst", xlab = "Pairwise Comparison", names.arg = pop_combo_names, las = 2)
  grDevices::dev.off() # close pdf
  
  viols <- unlist(pop_combo_names)[which(unlist(pair_fst_diff) == boxplot.stats(unlist(pair_fst_diff))$out)] # ID which populations are violating the model by calculating outliers
  if (identical(viols,character(0))){
    viols = "None"
  }
  
  return(viols)
                        
}