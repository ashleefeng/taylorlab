#! /usr/bin/env python

"""
Remove NNN..NNN sequences from a fasta file
Xinyu Feng, March 3, 2018
"""

import sys

if len(sys.argv) == 1:
	print("Usage: ./011-NNN_remover.py <file.fasta> > <out.fasta>")
	quit()

file = open(sys.argv[1])
outfile = open(sys.argv[2], 'w')
header = ""

num_rm = 0
total = 0

for line in file:

	if header == "":
		# previous line is not a header (beginning or a sequence line)
		assert (line[0] == '>'), "Fasta file format error!"
		header = line
		continue

	else:
		chars = set(list(line))
		total += 1
		if 'N' in chars:
			header = ""
			num_rm += 1
			continue
		else:
			outfile.write(header)
			outfile.write(line)
			header = ""
			continue

outfile.close()
file.close()

print("Removed %d sequences from a total of %d sequences." %(num_rm, total))


