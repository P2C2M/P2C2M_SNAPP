### Function for converting sequence data from FastSimCoal to binary format ###

convert2binary <- function(allele1, allele2, randomstart){
  
  binary_seq <- list()
  if (allele1 == "0" && allele2 == "0"){
    binary_seq <- append(binary_seq, "0", after = length(binary_seq))
  } else if (allele1 == "1" && allele2 == "1"){
    binary_seq <- append(binary_seq, "2", after = length(binary_seq))
  } else {
    binary_seq <- append(binary_seq, "1", after = length(binary_seq))
  }
  
  binary_seq <- mapply(randomize_binary, binary_seq, randomstart) # randomize 0s and 2s
  
  return(binary_seq)
}
