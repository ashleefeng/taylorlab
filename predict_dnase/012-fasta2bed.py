#! /usr/bin/env python

import sys

"""
Convert fasta files extracted using bed files back to bed files
(perhaps after sequences like NNN are removed)

by Xinyu Feng, March 2, 2018
"""

if len(sys.argv) == 1:
	print "Usage: ./012-fasta2bed.py <file.fa> <out.fa>"
	print "<file.fa> sequence names need to look like chrN:start-end"
	quit()

fasta = open(sys.argv[1])
bed = open(sys.argv[2], 'w')

for line in fasta:
	if line[0] == '>':
		header = line.rstrip('\n').lstrip('>')
		tokens = header.split(':')
		chrom = tokens[0]
		startend = tokens[1].split('-')
		start = startend[0]
		end = startend[1]

		bed.write('\t'.join([chrom, start, end]))
		bed.write('\n')

fasta.close()
bed.close()

