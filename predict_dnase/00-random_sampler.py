#!/usr/bin/env python

"""
Usage: ./00-random_sampler.py [peaks.bed] [ref.fasta]
Xinyu (Ashlee) Feng
"""

import sys
import pandas as pd
import numpy as np

# read peaks file and ref genome

peaks = pd.read_csv("/Users/cmdb/taylor/rotation/data/dnase/hs/A549/processed/rep2/ENCFF135JRM.bed",\
	sep='\t', header=None, names=["chrom", "start", "end", "name", "score", "strand", "thickStart",\
	"thickEnd", 8, 9])

# # for testing
# peaks = pd.read_csv("00-test.bed",\
# 	sep='\t', header=None, names=["chrom", "start", "end", "name", "score", "strand", "thickStart",\
# 	"thickEnd", 8, 9])
peaks.sort_values(by=["chrom", "start"], inplace=True)
num_peaks = peaks.shape[0]

refidx = pd.read_csv("/Users/cmdb/taylor/rotation/ref/hs/hg38.fa.fai", '\t', header=None, \
	names=["chrom", "length", 2, 3, 4])
refidx.sort_values(by=["chrom"], inplace=True)

# number --> chromosome name

n2chr = {}

for i in range(21):
	n2chr[i] = "chr" + str(i + 1)

n2chr[21] = "chrX"
n2chr[22] = "chrY"

# chromosome name --> length

chr2len = {}
chr_set = set(n2chr.values())

for index, row in refidx.iterrows():
	if row["chrom"] in chr_set:
		chr2len[row["chrom"]] = row["length"]

# chromosome name --> row# in the table

chr2row = {}
row_counter = 0
for index, row in peaks.iterrows():

	if (row["chrom"] not in chr2row) and (row["chrom"] in chr_set):
		chr2row[row["chrom"]] = row_counter

	row_counter += 1

# print chr2row

# # test iloc
# print "\nTesting iloc..."
# print peaks.iloc[28860:28863]

# where results are stored

nonpeaks = pd.DataFrame(index=range(num_peaks), columns=["chrom", "start", "end"])

counter = 0

for index, row in peaks.iterrows():

	# print "\nPeak " + str(counter)
	# print row
	dhs_len = row["end"] - row["start"] + 1
	# print dhs_len
	repick = True

	while repick:

		# pick random chrom
		rand_chrom = n2chr[np.random.randint(0, 23)]
		# print "Picked chromosome " + rand_chrom

		# pick start site
		rand_start = np.random.randint(0, chr2len[rand_chrom] - dhs_len)
		rand_end = rand_start + dhs_len - 1
		# print "Random start: " + str(rand_start)
		# print "End: " + str(rand_end)

		row_i = chr2row[rand_chrom]

		# check if the random region overlaps with DHS
		# if yes, then repick

		while peaks.iloc[row_i]["chrom"] == "rand_chrom":

			row_i_content = peaks.iloc(row_i)
			row_i_start = row_i_content["start"]
			row_i_end = row_i_content["end"]

			if ((rand_start >= row_i_start) and (rand_start <= row_i_end)) or \
			   ((rand_end >= row_i_start) and (rand_end <= row_i_end)):       
			   
			   # need to repick
			   print "Row " + str(counter) + " Random region overlapped with peak " + row_i_content["name"] + ". Need to repick."

			   break

			row_i += 1

			if row_i == num_peaks:
				repick = False

				# print "Reached the end of file. No overlap!"

				break

		else:
			repick = False
			# print "Compared with all DHS on this chromosome. No overlap!"

	nonpeaks.iloc[counter] = [rand_chrom, rand_start, rand_end]

	counter += 1

	if counter % 10000 == 0:
		print "Done with " + str(counter) + " rows."

	# # for testing
	# if counter == 5:
	# 	break

# print nonpeaks
nonpeaks.to_csv("nonpeaks.bed", sep='\t')
peaks.to_csv("peaks_sorted.bed", sep='\t')
	
	





