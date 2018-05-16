#! /usr/bin/env python

"""
Average coefficients/ranks and output in sorted order.

Xinyu Feng
March 5, 2018
"""

import pandas as pd 
import numpy as np 
import sys

if len(sys.argv) == 1:
	print "Usage: ./04-average_coeff.py <file1.tsv> <file2.tsv> ... <fileN.tsv> <out_prefix>"
	print "Note: columns must be: motif_ID | motif_name | coeff"
	quit()

num_files = len(sys.argv) - 2
out_prefix = sys.argv[-1]
outname = out_prefix + "_avg.tsv"

master_df = pd.DataFrame()

for i in range(num_files):
	df = pd.read_csv(sys.argv[i + 1], sep='\t', header=None, index_col=0) 
	# df = pd.read_csv(sys.argv[i + 1], sep='\t', header=None, skiprows=3, usecols=[1, 2, 3]) # for K562 logistic reg

	if master_df.empty:
		master_df = df

	df.sort_values(by=1, axis=0, inplace=True) # for K562 logistic reg
	print df.head()

	master_df[i+2] = df[2]


mean = master_df.mean(axis=1, numeric_only=True)
std = master_df.std(axis=1, numeric_only=True)
master_df["mean"] = mean
master_df["std"] = std
master_df.sort_values(by="mean", axis=0, inplace=True, ascending=False)
print master_df.head()

master_df.to_csv(outname, sep='\t', index=False, float_format='%.4f')

