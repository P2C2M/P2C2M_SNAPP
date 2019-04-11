### Function for simulating datasets and creating SNAPP xml files ###

simulation.xml <- function(trees.data, trees, snps, populations, pops, pops_n, pops_x, mut, growthrates, xml_file, delete_sims){
  
  for (t in 1:nrow(trees.data)){
    
    print(paste0("Preparing simulated dataset ", t))
    
    #get all thetas
    t.1<-trees.data[t,4]
    t.1<-as.character(t.1)
    
    theta<-list()
    for (i in 1:pops) {
      th<-strapply(t.1, paste(i,"\\[&theta=([^]]*)\\]", sep=""), back=-1)
      th<-as.numeric(th)
      theta[i]<-th
    }
    
    #calculate pop sizes
    Ne <- function(x) {x / (4*mut)} 
    pops_Ne<-lapply(theta, Ne)
    pops_e<-paste(pops_Ne, collapse="\n")
    
    #create input for historical events
    tr <- trees[t]
    
    # get historical events
    he <- historical_events(tr, pops_Ne, mut)
    events_n <- he[1]
    h <- he[2]
    
    #build simcoal file for this pull from posterior
    simcoal_input_file <- paste("//Number of population samples (demes)","\n", length(pops_n), " samples to simulate:","\n", "//Population effective sizes (number of genes)","\n", pops_e,"\n", "//Sample sizes","\n", pops_x,"\n", "//Growth rates	: negative growth implies population expansion","\n", growthrates,"\n", "//Number of migration matrices : 0 implies no migration between demes","\n", 0,"\n", "//historical event: time, source, sink, migrants, new size, new growth rate, migr. matrix","\n", events_n," historical events","\n", h,"\n", "//Number of independent loci [chromosome]","\n", snps,"\n", "//Per chromosome: Number of linkage blocks","\n", 1, "\n", "//per Block: data type, num loci, rec. rate and mut rate + optional parameters","\n", "SNP 1 0.00000 0.00000" ,sep="")
    
    #write .par fil for fastsimcoal
    sim <- paste0("simcoal_input_", t, ".par")
    write.table(data.frame(simcoal_input_file), file=sim, col.names=F, row.names=F, quote=F)
    
    #call simcoal with command
    sys_cmd <- paste0("./fsc26 -i simcoal_input_", t, ".par -n 1 -g")
    system(sys_cmd, ignore.stdout = TRUE)
    
    # write xml file for SNAPP
    #create_xml(xml_file, populations, pops_n, snps, delete_sims)
    
  }  
  
  # write xml files for SNAPP
  create_xml(xml_file, populations, pops_n, snps, delete_sims)
  
}


