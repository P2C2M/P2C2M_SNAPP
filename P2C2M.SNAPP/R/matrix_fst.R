##### Function to obtain snp matrix and calculate fst values for a single dataset #####

matrix_fst <- function(xml_name, pop_combo_list, populations){
  
  ### Create SNP matrix
  snp_matrix <- create_snp_matrix(xml_name)
  
  ### Calculate Fst values
  fst_list <- as.numeric(lapply(pop_combo_list, function(x) KRIS::fst.hudson(snp_matrix, seq(unlist(populations[,3][x[[1]][[1]]]), unlist(populations[,4][x[[1]][[1]]])), seq(unlist(populations[,3][x[[2]][[1]]]), unlist(populations[,4][x[[2]][[1]]])))))
  
  return(fst_list)
  
}
