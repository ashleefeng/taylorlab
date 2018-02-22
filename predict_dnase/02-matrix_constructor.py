#! /usr/bin/env python

import numpy as np 
import pandas as pd 
import sys

"""
Construct the training set and test set for training the open chromatin predictor

Usage: ./02-matrix_constructor.py <file.bed> <fimo_out.txt> <pwm_ids.txt> <out.csv> 
Example: ./02-matrix_constructor.py peaks_sorted.bed temp2.txt human_pwm_ids_sorted.txt peaks_matrix_test

Xinyu Feng Feb 19, 2018
"""

bed = pd.read_csv(sys.argv[1], sep='\t', header=None)
fimo = pd.read_csv(sys.argv[2], sep = '\t')
pwm_ids = pd.read_csv(sys.argv[3], sep = ' ', header=None)
out_name = sys.argv[4]

# print bed.head(10)
# print fimo.head()
# print pwm_ids.head(10)

# create map: location -> row number

loc2row = {}

for index, row in bed.iterrows():

	chrN = row[0].lstrip("chr")
	loc2row[(chrN, row[1], row[2])] = index

# print len(loc2row)

# create map: motif_id -> column number

motif2col = {}

# test = 0
for index, row in pwm_ids.iterrows():
	motif2col[row[1]] = index

	# test += 1
	# if test == 10:
	# 	break

# print motif2col

# initialize matrix
num_rows = bed.shape[0]
num_cols = pwm_ids.shape[0]
mat = np.zeros(shape=(num_rows, num_cols), dtype=np.uint8) # uint: 0-255
# print mat.shape


test = 0

# iterate over all motif search results

for index, row in fimo.iterrows():

	test += 1
	if test % 400000 == 0:
		print "Done with " + str(test) + ' rows!'

	loc = row["sequence_name"]
	motif = row["# motif_id"]
	tokens = loc.split(':')
	chrN = tokens[0].lstrip('chr')
	startend = tokens[1]
	start = int(startend.split('-')[0])
	end = int(startend.split('-')[1])

	# print row
	# print loc
	# print motif
	# print chrN, start, end
	curr_row = loc2row[(chrN, start, end)]
	curr_col = motif2col[motif]

	# print curr_row, curr_col

	mat[curr_row][curr_col] += 1

np.savetxt(out_name + '.tsv', mat, fmt='%d', delimiter='\t')
















