
p2c2m.snapp <- function(xml_file = "snapp.xml", num_sims = 1000, dist_reps = 100, delete_sims = TRUE, save_output = TRUE, run_mode = 1){
  
  # Arguments:
  #   xml_file = name of the xml file that was used to run SNAPP with the empirical dataset
  #   num_sims = number of draws from the empirical posterior to simulate datasets from = number of simulated datasets
  #   dist_reps = number of trees from the simulated posterior to compare to the posterior tree they were simulated from
  #   delete_sims = if TRUE, simulation files are deleted after xml files are created
  #   save_output = if TRUE, results are written to a file
  #   run_mode = specifies whether to simulate data and prepare xml files from the empirical data (1) OR calculate summary statistics and compare between empirical and simulated data (2)
  #   Note: p2c2m.snapp assumes that the user runs the simulated dataset xml files in SNAPP (probably on a cluster) between run_mode = 1 and run_mode = 2
  #         tree files and log files from the simulated dataset SNAPP runs must be placed in the same working directory 
  
  
  if (run_mode == 1){
    
    library(ape)
    library(gsubfn)
    library(ggtree)
    library(grDevices)
    library(ggplot2)
    library(utils)
    library(stats)
    
    ######################################################
    # GET VARIABLES FROM USER
    ######################################################
    
    cat("Reading samples.txt file\n\n")
    
    #read in file with sample info (tab delimited file called samples.txt)
    sample<-read.table("samples.txt", sep="\t", fill=T, header=F)
    
    #get number of SNPs
    snps<-sample[1,1]
    
    #get population samples
    populations<-sample[4:nrow(sample),]
    
    total_n<- sum(populations[,2])
    
    pops<-nrow(populations)
    pops_n<- populations[,2] * 2 # multiply by 2 to make diploid individuals
    
    pops_x<-paste(pops_n, collapse="\n")
    
    #growthrates
    growthrates <- rep.int(0, pops) # create list of growth rates (always = 0)
    growthrates<-paste(growthrates, collapse="\n")
    
    mut<-sample[2,1]
    
    gens_run<-sample[3,1] # changed because generation time is not needed for branch length -> historical event time conversion
    
    
    ###############################################################
    #get information from each tree in posterior
    ###############################################################
    
    cat("Reading posterior trees\n\n")
    
    post_samples <- draw.samples(num_sims, gens_run) # select samples from posterior
    
    suppressWarnings(trees.data<-read.table("snap.trees", skip = (10 + 2*as.numeric(pops)))[post_samples,]) # get tree data and subset
    trees<-snapptree.reader("snap.trees", post_samples, pops) # subset and read in trees
    
    
    ##############################################################
    # Simulate new datasets and create xml files for SNAPP
    ##############################################################
    
    simulation.xml(trees.data, trees, snps, populations, pops, pops_n, pops_x, mut, growthrates, xml_file, delete_sims)
    
    
    ##############################################################
    # Create interim file for values to be used during analysis
    ##############################################################
    
    int_file <- file("intermediate.txt", "w+")
    ps <- paste(unlist(post_samples), collapse = "\t")
    writeLines(paste(ps, pops, sep = "\n"), int_file)
    close(int_file)
    
    
    cat("Simulations Finished")
  }
  
  
  if (run_mode == 2){
    
    library(ape)
    library(grDevices)
    
    ##############################################################
    # Read in values from interim file
    ##############################################################
    
    int <- file("intermediate.txt", "r")
    int_lines <- readLines(int)
    close(int)
    
    post_samples <- lapply(strsplit(int_lines[1], "\t")[[1]], function(x) as.numeric(x))
    
    pops <- as.numeric(int_lines[2])
    
    
    ##############################################################
    # Read in posterior trees
    ##############################################################
    
    trees<-snapptree.reader("snap.trees", unlist(post_samples), pops) # subset and read in trees
    
    
    ##############################################################
    # Calculate summary statistics and assess significance
    ##############################################################
    
    cat("Calculating and assessing summary statistics\n\n")
    
    stats <- sum.stats(xml_file, trees, post_samples, pops, dist_reps)
    
    out_table <- cbind(c("KF", "RF", "MLM", "MLSD", "FSTave", "FSTran"), stats[1:6])
    colnames(out_table) <- c("Stat", "p")
    
    if (save_output == TRUE){
      write.table(out_table, "p2c2m.out", row.names = FALSE)
    }
    
    cat("P2C2M Completed\n\n")
    print(out_table)
    cat(paste("Comparisons likely to violate model:\n", stats$pair_fst_viols))
    
    ### For testing purposes
    write.csv(stats, "P2C2Mout.csv", row.names = FALSE)
    
  }
}




  