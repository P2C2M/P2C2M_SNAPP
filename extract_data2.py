def extract_data(file_name, npops, indsperpop):
	
	import numpy
	from randomize_binary import randomize_binary
	
	arp_file = open(file_name, 'r') # open file connection
	arp_lines = arp_file.readlines() # read in all lines
	arp_file.close() # close file connection
	
	nloci = int(arp_lines[16].split(': ')[1]) # get number of loci
	
	gtype_lines = arp_lines[(18+(2*nloci))-2:((18+(2*nloci))-2) + npops*((indsperpop*2)+5)] # extract genotype lines 
	
	randomstart = list(numpy.random.choice([0,2], nloci)) # create random list of 0s and 2s so 0s are not assumed to be ancestral
	randomstart = list(map(str, randomstart)) # convert list of ints to list of strings
	
	taxa_names = []
	seqs = []
	
	for pop in range(1, npops+1, 1):
		pop_lines = gtype_lines[(5*pop)+((pop - 1) * 2 * indsperpop): (5*pop) + (pop*2*indsperpop)] # separate gtype lines for population/species
		
		for ind in range(0,indsperpop,1):
			gtype = pop_lines[2*ind:(2*ind)+2] #get individual genotype
			
			taxa_names.append(gtype[0].split('\t')[0]) # get taxa name
			
			seq1 = gtype[0].split('\t')[2].replace(' ','').replace('\n','') # get sequence 1
			seq2 = gtype[1].split('\t')[2].replace(' ','').replace('\n','') # get sequence 2
			
### Convert to binary format where 00 = 0, 11 = 2, and 01 or 10 = 1
			seq = []
			for locus in range(0, nloci, 1):
				if seq1[locus] == '0' and seq2[locus] == '0': # convert homozygotes to binary
					seq.append('0')
				elif seq1[locus] == '1' and seq2[locus] =='1': # convert homozygotes to binary
					seq.append('2')
				else: # convert heterozygotes to binary
					seq.append('1')
			
			seq = randomize_binary(seq, randomstart)
			
			seq = ''.join(seq) # collapse snp strings		
			seqs.append(seq)
	
	return([seqs, taxa_names])