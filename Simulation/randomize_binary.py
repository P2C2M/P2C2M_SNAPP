##### Script for randomizing designation of binary 0s and 2s #####
##### Note: randomstart is the list to convert 0s to #####

def randomize_binary(seq, randomstart):

	for n in range(0, len(seq), 1):
		if seq[n] == '0':
			seq[n] == randomstart[n]
		elif seq[n] == '2' and randomstart[n] == '2':
			seq[n] == '0'
		elif seq[n] == '2' and randomstart[n] == '0':
			seq[n] == '2'
		elif seq[n] == '1':
			continue
		else:
			print('Randomization Error' + '\t' + seq[n])
			
		return(seq)
