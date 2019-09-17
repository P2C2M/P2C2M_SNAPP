#' Posterior predictive checks of SNAPP analyses
#'
#' \code{run.p2c2m.snapp} simulates posterior predictive datasets and compares them to the empirical dataset to identify model violations
#'
#' @param path_to_xml String. The path to the xml input files. Also the path that files will be written to
#' @param xml_file String. The .xml file in working directory. The empirical .xml file used as input for SNAPP.
#' @param sum_stat A string or vector of strings. Which summary statistics to test. RF = Robinson Foulds distance, MLSD = standard deviation of tree
#'  likelihoods, PFST = Fst outlier test.
#' @param num_sims Numeric. Number of posterior predictive datasets to simulate.
#' @param dist_reps Numeric. Number of trees from the posterior predictive distribution to compare to the posterior tree the data was simulated from.
#' @param sample_unif Logical. If TRUE, sample posterior at regular interval. Otherwise, randomly sample.
#' @param delete_sims Logical. Should intermediate simulation files be deleted?
#' @param save_graphs Logical. Should graphs of each summary statistic be saved to files?
#' @param save_output Logical. Should output be saved to a file?
#' @param run_mode Numeric. Whether to simulate data and prepare xml files from the empirical data (1) OR calculate summary statistics and compare between    #'  empirical and simulated data (2)
#'
#' @return Posterior predictive datasets and .xml files will be created in the current working directory if run = 1. If run = 2, PDF files will be
#'  created showing histograms of each summary statistic, and two files will be created with a summary of the results.
#'
#' @examples
#' \donttest{
#' run.p2c2m.snapp(path_to_xml = tempdir(), xml_file = "snapp.xml",
#'                 sum_stat = c("RF", "MLSD", "PFST"), num_sims = 100, dist_reps = 100,
#'                 sample_unif = TRUE, delete_sims = FALSE, save_graphs = TRUE,
#'                 save_output = TRUE, run_mode = 1)
#' run.p2c2m.snapp(path_to_xml = tempdir(), xml_file = "snapp.xml",
#'                 sum_stat = c("RF", "MLSD", "PFST"), num_sims = 100, dist_reps = 100,
#'                 sample_unif = TRUE, delete_sims = FALSE, save_graphs = TRUE,
#'                 save_output = TRUE, run_mode = 2)
#' }
#'
#' @export
#'
run.p2c2m.snapp <- function(path_to_xml, xml_file = "snapp.xml", sum_stat = c("RF", "MLSD", "PFST"), num_sims = 100, dist_reps = 100, sample_unif = TRUE, delete_sims = FALSE, save_graphs = TRUE, save_output = TRUE, run_mode = 1){

  # Arguments:
  #   path_to_xml = path to the xml input files. Also the path that files will be written to
  #   xml_file = name of the xml file that was used to run SNAPP with the empirical dataset
  #   num_sims = number of draws from the empirical posterior to simulate datasets from = number of simulated datasets
  #   dist_reps = number of trees from the simulated posterior to compare to the posterior tree they were simulated from
  #   sample_unif = If TRUE, sample posterior at regular interval. Otherwise, randomly sample.
  #   delete_sims = if TRUE, simulation files are deleted after xml files are created
  #   save_graphs = if TRUE, descriptive histograms are written for the analysis of each summary statistic
  #   save_output = if TRUE, results are written to a file
  #   run_mode = specifies whether to simulate data and prepare xml files from the empirical data (1) OR calculate summary statistics and compare between empirical and simulated data (2)
  #   Note: run.p2c2m.snapp assumes that the user runs the simulated dataset xml files in SNAPP (probably on a cluster) between run_mode = 1 and run_mode = 2
  #         tree files and log files from the simulated dataset SNAPP runs must be placed in the same working directory


  home_wd <- getwd() # get home directory
  setwd(path_to_xml) # set working directory
  on.exit(setwd(home_wd))

  if (run_mode == 1){


    ######################################################
    # GET VARIABLES FROM USER
    ######################################################

    print("Reading samples.txt file")

    #read in file with sample info (tab delimited file called samples.txt)
    samp<-utils::read.table("samples.txt", sep="\t", fill=T, header=F)

    #get number of SNPs
    snps<-samp[1,1]

    #get population samples
    populations<-samp[4:nrow(samp),]

    total_n<- sum(populations[,2])

    pops<-nrow(populations)
    pops_n<- populations[,2] * 2 # multiply by 2 to make diploid individuals

    pops_x<-paste(pops_n, collapse="\n")

    #growthrates
    growthrates <- rep.int(0, pops) # create list of growth rates (always = 0)
    growthrates<-paste(growthrates, collapse="\n")

    mut<-samp[2,1]

    gens_run<-samp[3,1] # changed because generation time is not needed for branch length -> historical event time conversion


    ###############################################################
    #get information from each tree in posterior
    ###############################################################

    cat("Reading posterior trees\n\n")

    post_samples <- draw.samples(num_sims, gens_run, sample_unif) # select samples from posterior

    suppressWarnings(trees.data<-utils::read.table("snap.trees", skip = (10 + 2*as.numeric(pops)))[post_samples,]) # get tree data and subset
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


    print("Simulations Finished")
  }


  if (run_mode == 2){


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
    if ("RF" %in% sum_stat == TRUE | "MLSD" %in% sum_stat == TRUE){

      strees<-snapptree.reader("snap.trees", unlist(post_samples), pops) # subset and read in trees

    }

    ##############################################################
    # Calculate summary statistics and assess significance
    ##############################################################

    print("Calculating and assessing summary statistics")

    if ("RF" %in% sum_stat == TRUE | "MLSD" %in% sum_stat == TRUE){
      stats <- sum.stats(xml_file, strees, post_samples, pops, dist_reps, sum_stat, save_graphs)

      out_table <- cbind(sum_stat, stats[1:length(sum_stat)])
      colnames(out_table) <- c("Stat", "p")

      if (save_output == TRUE){
        utils::write.table(out_table, "p2c2m.out", row.names = FALSE)
      }
    }

    if ("RF" %in% sum_stat == FALSE & "MLSD" %in% sum_stat == FALSE){
      stats <- sum.stats(xml_file, NULL, post_samples, pops, dist_reps, sum_stat, save_graphs)

      out_table <- cbind(sum_stat, stats[1])
      colnames(out_table) <- c("Stat", "p")

      if (save_output == TRUE){
        utils::write.table(out_table, "p2c2m.out", row.names = FALSE)
      }
    }

    cat("P2C2M Completed\n\n")

    for (m in seq(1, length(out_table[,1]))){
      print(paste(out_table[m,1], out_table[m,2], collapse = "\t"))
    }

    if ("PFST" %in% sum_stat == TRUE){
      print(paste("Comparisons likely to violate model:", stats$pair_fst_viols))
    }

    ### For testing purposes
    if (save_output == TRUE){
      utils::write.csv(stats, "P2C2Mout.csv", row.names = FALSE)
    }
  }
}




