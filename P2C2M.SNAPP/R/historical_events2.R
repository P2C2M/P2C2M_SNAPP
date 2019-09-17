##### Function for getting historical event information from trees #####

historical_events<- function(tr, pops_Ne, mut){

  #order and times of coalescent events
  d=ggtree::fortify(tr)
  sizes <- rep.int(0, nrow(d)) # create list to hold Ne values
  d <- cbind(d, sizes) # add sizes column to dataframe
  d$sizes[1:length(pops_Ne)] <- pops_Ne # change population sizes of extant populations
  d <- d[order(d$x, decreasing = TRUE),] # arrange by time from present

  #get events
  events<-d[d$isTip == FALSE,]$node # get nodes (events) in order from present
  events_n<-length(events)

  max_time <- max(d$x) # get time between basal node and present

  #get events
  history<-list()

  for (j in events){
    l<-d [ which(d$parent==j),]
    l<- l[which(l$x!=0),]
    time_t <- max_time - min(l$x) + min(l$branch.length) # weird experimental equation to get time since present. MUST BE TESTED MORE!

    pop_1 <- l$label[1]
    pop_1<-as.numeric(pop_1)

    pop_2<-l$label[2]
    pop_2<-as.numeric(pop_2)

    pop_1_migrants <- as.numeric(l$sizes[1]) # get Ne of pop1
    pop_2_migrants <- as.numeric(l$sizes[2]) # get Ne of pop2

    newsize = pop_1_migrants + pop_2_migrants # get Ne of ancestral pop
    d[which(d$node == j),]$sizes <- newsize # add size of ancestral population to dataframe
    size_prop <- newsize / pop_2_migrants # # get Ne size change proportion

    time <- time_t /mut ##### branch lengths in subs/site? If so, time(in gen) = time_t / mut

    source <- as.numeric(pop_1) - 1 # fsc pop labeling starts at 0
    sink <- as.numeric(pop_2) - 1 # fsc pop labeling starts at 0
    d[which(d$node == j),]$label <- pop_2

    temp<-paste(time, source, sink, 1, size_prop, 0, 0, sep=" ") # create historical event line

    history<- append(history, temp, after = length(history))
  }

  h<-paste(history, collapse="\n")

  he <- list(events_n, h)
  return(he)

}
