##### Function for calculating and comparing Fst values #####

calc.fst <- function(xml_file){
  
  #read in file with sample info (tab delimited file called samples.txt)
  sample<-read.table("samples.txt", sep="\t", fill=T, header=F)
  
  #get population samples
  populations<-sample[4:nrow(sample),]
  
  ### create population vectors
  n_pops <- nrow(populations)
  additive_pops_start <- lapply(seq(1, n_pops), function(x) sum(populations[1:x,2])-populations[x,2] + 1) # get starting numbers for each population in sequence list
  additive_pops_end <- (unlist(additive_pops_start) - 1)[2:n_pops] # get ending numbers for each population in sequence list
  additive_pops_end <- append(additive_pops_end, sum(populations[,2]), after = length(additive_pops_end)) # add last ending number
  
  populations <- cbind(populations, cbind(additive_pops_start, additive_pops_end)) # add starting and ending numbers to populations dataframe
  pop_combo_matrix <- as.data.frame(combn(1:n_pops, 2)) # get all combinations of pairwise population comparisons
  pop_combo_list <- lapply(pop_combo_matrix, function(x) as.list(x)) # turn matrix into list
  
  ### Calculate Fst for empirical data
  empirical_fst <- matrix_fst(xml_file, pop_combo_list, populations) # calculate empirical fst values
  empirical_average <- mean(as.numeric(empirical_fst)) # calculate empirical average
  empirical_range <- max(as.numeric(empirical_fst)) - min(as.numeric(empirical_fst)) # calculate empirical range
  
  
  ### Calculate Fst for predictive datasets
  xml_files <- list.files(pattern = "*.xml") # get list of all xml files in directory
  sim_xmls <- xml_files[which(xml_files != xml_file)] # remove empirical xml
  sim_xmls <- sim_xmls[which(grepl("*.state", sim_xmls) != TRUE)]
  sim_fst_list <- lapply(sim_xmls, function(x) matrix_fst(x, pop_combo_list, populations)) # calculate predictive fst values
  
  
  sim_average <- lapply(sim_fst_list, mean) # calculate simulation averages
  sim_range <- lapply(sim_fst_list, function(x) max(x) - min(x)) # calculate simulation ranges
  
  ### Compare and assess Fst significance
  p_fst_average <- compare.fst(empirical_average, sim_average) # compare fst averages
  p_fst_range <- compare.fst(empirical_range, sim_range) # compare fst ranges
  
  hist.writer("Fst_Average", empirical_average, unlist(sim_average))
  hist.writer("Fst_Range", empirical_average, unlist(sim_range))
  
  pair_fst_viols <- id_pairwise_fst(pop_combo_list, empirical_fst, sim_fst_list) # identify populations sharing genes
  
  fst_result_list <- list(unlist(p_fst_average), unlist(p_fst_range), pair_fst_viols) # combine results to list
  
  return(fst_result_list)
}
