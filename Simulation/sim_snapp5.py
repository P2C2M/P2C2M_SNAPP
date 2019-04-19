##### Script for simulating data for analysis with SNAPP/P2C2M #####

import glob
import re
import subprocess
import os
import numpy
from extract_data2 import extract_data
from write_snapp3 import write_snapp
from write_par import write_par

### Define Variables
npops = 6 # number of species/populations
indsperpop = 2 # number of samples per pop/species
sim_reps = 1 # number of simulations to perform for each model
model = '1' # no migration = 1, migration = 3
mig_low = 0.000005
mig_high = 0.00005
wd = os.getcwd() + '/' # get working directory
wd = wd.replace(' ', '\ ') # format spaces in directory
sim_log = open('sim_log.txt', 'w+') # create log for keeping track of migration values
sim_log.writelines('Rep,Mig,p1,p2' + '\n') # write header line


for rep in range(0,sim_reps,1):
	
	mig_rate = numpy.random.uniform(mig_low, mig_high) # select migration rate
	pops = numpy.random.choice(6, size = (1,2), replace = False) # randomly pick two populations to exchange genes
	pops = list(map(list, pops)) # reformat to list
	mig = [mig_rate, pops[0][0], pops[0][1]]
	sim_log.writelines(str(rep) + ',' + str(mig[0]) + ',' + str(mig[1]) + ',' + str(mig[2]) + '\n') # write values to log
	
	
### Prepare par file for simulation	
	par_dir = 'model' + model + '_' + str(rep) # create name for par directory
	par_name = par_dir + '.par' # create name for par file
	write_par(par_name, npops, indsperpop, mig) # write the par file
	
### Simulate Data
	fsc_cmd = './fsc26 -i {0} -n 1 -g'.format(par_name)
	subprocess.call(fsc_cmd, shell = True) # run fsc
	wd_cmd = 'mv {0}/* {1}'.format(par_dir, wd)
	subprocess.call(wd_cmd, shell = True) # move all files to current working directory


arp_names = glob.glob('*.arp') # get all arp file names
for file_name in arp_names:
	
### Convert SNPs to binary format, extract sample names and snps
	data = extract_data(file_name, npops, indsperpop)
	seqs = data[0]
	taxa_names = data[1]
	
### Prepare SNAPP xml file
	write_snapp(file_name, npops, indsperpop, taxa_names, seqs) # write nexus file for snapp
