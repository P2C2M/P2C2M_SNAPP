### Function for writing SNAPP xml files ###

write_xml <- function(wd, arp, xml_file, pops_n, populations, snps, a1, a2){
  
  wdd <- paste0(wd, "/")
  sim_name <- strsplit(tail(strsplit(unlist(arp), "/")[[1]], n = 1), ".arp")[[1]] # get file name without extension
  xml_name <- paste0(sim_name, ".xml") # create name of new xml file
  xml <- file(xml_file, "r") # open connection to original xml file
  xml_lines <- readLines(xml) # read in xml lines
  close(xml)
  
  run_name <- strsplit(xml_lines[5], '\"')[[1]][2] # get run name of original snapp analysis
  seq_start <- grep("<sequence", xml_lines)[1] - 1 # get line number before sequences
  seq_end <- grep("</data>", xml_lines)[1] # get line number after sequences
  taxon_start <- grep("<taxonset id", xml_lines)[1] - 1 # get line number before taxon id lines
  taxon_end <- grep("</taxa>", xml_lines)[1] # get line number after taxon id lines
  
  xml_lines <- lapply(xml_lines, function(x) gsub(run_name, sim_name, x)) # replace original snapp run name with simulation run name
  datatype_line <- 'dataType="integer"' # create line to indicate binary format
  xml_lines <- lapply(xml_lines, function(x) gsub('dataType="\\*"', datatype_line, x)) # replace previous format with binary format
  #xml_lines <- lapply(xml_lines, function(x) gsub('snap.log', paste0(sim_name, '.log'), x)) # replace log file name
  #xml_lines <- lapply(xml_lines, function(x) gsub('snap.trees', paste0(sim_name, '.trees'), x))
  
  head_lines <- paste(xml_lines[1:seq_start], sep = "\n") # get lines before seuences
  mid_lines <- paste(xml_lines[seq_end:taxon_start], sep = "\n") # get lines between sequences and taxon id lines
  tail_lines <- paste(xml_lines[taxon_end:length(xml_lines)], sep = "\n") # get lines after taxon id lines
  
  randomstart <- sample(c(0,2), size = snps, replace = TRUE) # create random list of 0s and 2s so 0s are not assumed to be ancestral - for randomize_binary function
  randomstart <- unlist(lapply(randomstart, as.character))
  
  new_xml <- file(xml_name, "w+") # create new xml file
  writeLines(head_lines, con = new_xml) # write lines before sequences
  
  # write sequences
  for (p in 1:length(pops_n)){ # for each population
    
    inds <- populations[p,2] # get number of inds
    
    for (i in 1:inds){ # for each ind
      
      seq_name <- paste0("seq_", p, "_", i) # create sequence name
      taxon_name <- paste0(p, "_", i) # create taxon name
      hap1 <- strsplit(a1[[p]][[i]][1], "")[[1]] # separate SNPs for allele 1
      hap2 <- strsplit(a2[[p]][[i]][1], "")[[1]] # separate SNPs for allele 2
      gtype <- paste(mapply(convert2binary, hap1, hap2, randomstart), collapse = "") # convert SNPs to binary format
      
      seq_line <- paste0('                    <sequence id="', seq_name, '" taxon="', taxon_name, '" totalcount="3" value="', gtype, '"/>') # create sequence line
      writeLines(seq_line, con = new_xml) # write sequence line
      
    }
  }
  
  writeLines(mid_lines, con = new_xml) # write lines in between sequences and taxon id lines
  
  # write taxon id lines
  for (p in 1:length(pops_n)){ # for each population
    
    taxonset_line <- paste0('                <taxonset id="', p, '" spec="TaxonSet">') # create taxon set line (population/species line)
    writeLines(taxonset_line, con = new_xml) # write taxon set line
    
    inds <- populations[p,2] # get number of inds
    
    for (i in 1:inds){ # for each ind
      
      taxon_name <- paste0(p, "_", i) # create taxon name
      taxon_line <- paste0('                    <taxon id="', taxon_name, '" spec="Taxon"/>') # create taxon line
      writeLines(taxon_line, con = new_xml) # write taxon line
      
    }
    
    writeLines('                </taxonset>', con = new_xml) # write taxon set end line for each taxon set
    
  }
  
  writeLines(tail_lines, con = new_xml) # write final lines
  
  close(new_xml)

}


