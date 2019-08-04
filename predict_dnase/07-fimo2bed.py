#!/usr/bin/env python

import sys

if len(sys.argv) == 1:
	print "Usage: 07-fimo2bed.py <fimo.txt> <out.bed>"
	quit()

file = open(sys.argv[1])
out = open(sys.argv[2], 'w')

header = 1

for line in file:
	if header == 1:
		header = 0
		continue
	else:
		cols = line.rstrip('\n').split('\t')
		chrom = cols[2].split(':')[0]
		bed_start = cols[2].split(':')[1].split('-')[0]
		match_start = int(bed_start) + int(cols[3]) - 1
		match_end = int(bed_start) + int(cols[4]) - 1
		strand = cols[5]
		name = chrom + ':' + str(match_start) + '-' + str(match_end) + ':' + strand
		# p = cols[7]
		p = 0
		out.write("%s\t%d\t%d\t%s\t%s\n" %(chrom, match_start, match_end, name, p))

file.close()
out.close()

