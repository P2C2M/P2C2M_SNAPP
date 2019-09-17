### Function for creating SNAPP xml files from simulated data files ###

create_xml <- function(xml_file, populations, pops_n, snps, delete_sims){

  print("Writing xml files")

  wd <- getwd()
  dirs <- list.dirs(full.names = FALSE, recursive = FALSE) # get directories with simulations
  dirs <- lapply(dirs, function(x) paste(wd, x, sep = "/")) # format path
  sim_files <- lapply(dirs, function(x) list.files(x, pattern = "*.arp", full.names = TRUE, recursive = FALSE)) # get simulation file paths

  for (arp in sim_files){ # for each arp file

    arp_file <- file(unlist(arp), "r") # open connection to arp file
    readLines(arp_file, n = (16 + 2 * snps)) # read in header lines
    pop_lines <- list()

    for (p in 1:length(pops_n)){ # for each population
      readLines(arp_file, n = 5) # skip header lines
      plines <- readLines(arp_file, n = pops_n[p]) # read in snp lines
      pop_lines[[p]] <- plines # add snp lines to list

    }

    close(arp_file) # close file connection

    a1 <- lapply(pop_lines, function(x) lapply(x[c(TRUE, FALSE)], function(x) strsplit(strsplit(x, "\t")[[1]][3], " ")[[1]][2])) # get sequences for allele 1
    a2 <- lapply(pop_lines, function(x) lapply(x[c(FALSE, TRUE)], function(x) strsplit(strsplit(x, "\t")[[1]][3], " ")[[1]][2])) # get sequences for allele 2

    write_xml(wd, arp, xml_file, pops_n, populations, snps, a1, a2)
  }



  if (delete_sims == TRUE){
    print("Deleting intermediate files")
    unlink(unlist(dirs), recursive = TRUE)
    unlink("*.par")
    unlink("seed.txt")
  }

}




