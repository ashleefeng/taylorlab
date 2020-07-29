#!/usr/bin/env python

"""
Generate training matrix based on a privided list of TFs

Xinyu Feng, March 20, 2018
"""

import sys

if len(sys.argv) == 1:
	print "Usage: ./20-validate.py <all_matrix.tsv> <TFs.txt> <all_pwms.txt> <out_matrix.tsv>"

import pandas as pd

matrix_fname = sys.argv[1]
tfs_fname = sys.argv[2]
all_fname = sys.argv[3]
out_fname = sys.argv[4]

tfs = pd.read
