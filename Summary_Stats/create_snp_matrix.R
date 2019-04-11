##### Function to read xml files and extract sequence information #####

create_snp_matrix <- function(xml_name){
  
  xml <- file(xml_name, "r") # open connection to original xml file
  xml_lines <- readLines(xml) # read in xml lines
  close(xml)
  
  seq_inds <- grep("<sequence", xml_lines) # get line numbers of sequences
  seq_lines <- xml_lines[seq_inds] # get sequence lines
  
  seq_strings <- lapply(seq_lines, function(x) strsplit(strsplit(x, split = "value=\"")[[1]][2], split = "\"")[[1]][1]) # get sequence strings
  
  seq_strings2 <- lapply(seq_strings, function(x) unlist(lapply(lapply(x, function(x) strsplit(x, split = ""))[[1]][[1]], as.numeric))) # get sequences split by locus
  
  snp_mat <- as.matrix(do.call(rbind, seq_strings2)) # convert to matrix
  
  return(snp_mat)
}
