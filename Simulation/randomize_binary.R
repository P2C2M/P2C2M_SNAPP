### Function for randomizing binary 0s and 2s so 0s are not assumed to be ancestral ###

randomize_binary <- function(binary_allele, randomallele){
  
  new_seq <- list()
  
  if (binary_allele == "0"){
    new_seq <- append(new_seq, randomallele, after = length(new_seq))
  } else if (binary_allele == "2" && randomallele == "2"){
    new_seq <- append(new_seq, "0", after = length(new_seq))
  } else if (binary_allele == "2" && randomallele == "0"){
    new_seq <- append(new_seq, "2", after = length(new_seq))
  } else if (binary_allele == "1"){
    new_seq <- append(new_seq, "1", after = length(new_seq))
  } else {
    print("Randomization Error")
  }
  
  return(new_seq)
  
}
