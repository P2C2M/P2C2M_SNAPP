##### Function for writing par files for simulation #####

def write_par(par_name, npops, indsperpop, mig):
	
	import numpy
	
### Define variables
	pe = 200000 # population effective size (Ne x 2)
	sample_size = indsperpop * 2 # in terms of alleles
	growth = 0
	snps = 20 # number of snps
	
	mig_matrix = list()
	mig_line = list(('0.00000,' * npops).split(','))[0:npops] # create line for migration matrix
	for r in range(0,npops,1):
		mig_matrix.append(mig_line) # create line for each population	
	
	mig_matrix2 = [x[:] for x in mig_matrix]
	mig_matrix2[mig[1]][mig[2]] = str(mig[0]) # add migration to matrix
	mig_matrix2[mig[2]][mig[1]] = str(mig[0]) # add migration to matrix
	for z in range(0,npops,1):
		mig_matrix[z] = '\t'.join(mig_matrix[z])
		mig_matrix2[z] = '\t'.join(mig_matrix2[z])

	par = open(par_name, 'w+') # create par file
	
	par.writelines('\
//Number of population samples (demes)\n\
{0}\n\
//Population effective sizes (number of genes)\n\
'.format(npops))
	
	for p in range(0,npops,1):
		par.writelines('{0}\n'.format(pe))
		
	par.writelines('\
//Sample sizes\n')
	
	for s in range(0,npops,1):
		par.writelines('{0}\n'.format(sample_size))
		
	par.writelines('\
//Growth rates	: negative growth implies population expansion\n')
	
	for g in range(0,npops,1):
		par.writelines('{0}\n'.format(growth))
		
	par.writelines('\
//Number of migration matrices : 0 implies no migration between demes\n\
2\n\
//migration matrix\n')
	
	for m2 in range(0, npops, 1):
		par.writelines(mig_matrix2[m2] + '\n')
		
	par.writelines('\
//migration matrix\n')
	
	for m1 in range(0, npops, 1):
		par.writelines(mig_matrix[m1] + '\n')
		
	par.writelines('\
//historical event: time, source, sink, migrants, new size, new growth rate, migr. matrix \n\
6  historical event \n\
250000 0 0 0 1 0 1\n\
500000 0 1 1 1 0 1\n\
500000 4 5 1 1 0 1\n\
1000000 1 2 1 1 0 1\n\
1000000 5 3 1 1 0 1\n\
2000000 2 3 1 1 0 1\n\
//Number of independent loci [chromosome] \n\
{0} 0\n\
//Per chromosome: Number of linkage blocks\n\
1\n\
//per Block: data type, num loci, rec. rate and mut rate + optional parameters\n\
SNP 1 0.00000 0\n'.format(snps))
	
	par.close() # close file
		
	
		
	