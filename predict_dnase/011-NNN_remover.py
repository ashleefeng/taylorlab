#! /usr/bin/env python

import sys

if len(sys.argv) == 1:
	print "Usage: ./011-NNN_remover.py <file.fasta> > <out.fasta>"
	quit()


file = open(sys.argv[1])
outfile = open(sys.argv[2], 'w')
header = ""

for line in file:

	# previous line is not a header (beginning or a sequence line)

	if header == "":
		assert (line[0] == '>'), "Fasta file format error!"
		header = line
		continue

	else:
		chars = set(list(line))
		if 'N' in chars:
			# useless squence
			print header + line
			header = ""
			continue
		else:
			outfile.write(header)
			outfile.write(line)
			header = ""
			continue


