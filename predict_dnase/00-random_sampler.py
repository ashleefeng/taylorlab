#!/usr/bin/env python

"""
Usage: ./00-random_sampler.py [peaks.bed] [ref.fasta.fai]
Xinyu (Ashlee) Feng
Feb 22, 2018
"""

import sys
import pandas as pd
import numpy as np


"""
Uses binary search to determine whether the random region overlaps with any of the dnase peaks
Returns: True if there is an overlap
         False if not
"""
def test_overlap(peaks, rand_chrom, chr2row, chr2lastrow, target_start, target_end):

	lo = chr2row[rand_chrom]
	hi = chr2lastrow[rand_chrom]

	while lo < hi:
		
		# print "lo: ", lo
		# print "hi: ", hi

		mid = int(np.floor((lo + hi) / 2))

		mid_start = peaks.iloc[mid]["start"]
		# print "mid: ", mid

		if mid_start < target_start: # too big
			# print "Go to bottom half"
			lo = mid + 1

		elif mid_start > target_start: # too small
			# print "Go to top half"
			hi = mid - 1

		else:
			return True

	# if no hit, in the last iteration, lo should
	# point to the row below target_start

	above_start = peaks.iloc[lo-1]["start"]
	above_end = peaks.iloc[lo-1]["end"]
	
	below_start = peaks.iloc[lo]["start"]
	below_end = peaks.iloc[lo]["end"]

	if ((above_end < target_start) and \
	   (target_end < below_start)) or \
	   (above_start > target_end) or \
	   (below_end < target_start):

	   	# print "No overlap!"
		return False

	else:
		print "Overlap: ", above_end, target_start, target_end, below_start
		return True



# read peaks file and ref genome
bed_file = sys.argv[1]

peaks = pd.read_csv(bed_file, sep='\t', header=None, \
	names=["chrom", "start", "end", "name", "score", "strand", "thickStart",\
	"thickEnd", 8, 9])

refidx = pd.read_csv(sys.argv[2], '\t', header=None, \
	names=["chrom", "length", 2, 3, 4])

peaks.sort_values(by=["chrom", "start"], inplace=True)
num_peaks = peaks.shape[0]
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

# chromosome name --> first row# in the table

chr2row = {}
row_counter = 0

for index, row in peaks.iterrows():
	if (row["chrom"] not in chr2row) and \
	   (row["chrom"] in chr_set):
		chr2row[row["chrom"]] = row_counter
	row_counter += 1

# chromosome name --> last row# in the table

chr2lastrow = {}
for i in range(num_peaks):
	j = num_peaks - i - 1
	row = peaks.iloc[j]
	if (row["chrom"] not in chr2lastrow) and \
	   (row["chrom"] in chr_set):
	   chr2lastrow[row["chrom"]] = j 

# randomly sample genome to generate negative set

nonpeaks = pd.DataFrame(index=range(num_peaks), columns=["chrom", "start", "end"])
counter = 0

for index, row in peaks.iterrows():

	dhs_len = row["end"] - row["start"] + 1
	repick = True

	while repick:

		# pick random chrom
		rand_chrom = n2chr[np.random.randint(0, 23)]

		# pick start site
		rand_start = np.random.randint(0, chr2len[rand_chrom] - dhs_len)
		rand_end = rand_start + dhs_len - 1

		# check if the random region overlaps with DHS
		# if yes, then repick

		repick = test_overlap(peaks, rand_chrom, chr2row, chr2lastrow, rand_start, rand_end)

		if repick:
			print "Row " + str(counter) + " random region overlapped with a DNase peak. Need to repick."

	nonpeaks.iloc[counter] = [rand_chrom, rand_start, rand_end]

	counter += 1

	if counter % 10000 == 0:
		print "Done with " + str(counter) + " rows."


	### for debugging

	# if counter == 1:
	# 	break

bed_file_path = ".".join(bed_file.split('.')[:-1])
nonpeaks.to_csv(bed_file_path + "_nonpeaks.bed", sep='\t')
peaks.to_csv(bed_file_path + "_peaks_sorted.bed", sep='\t')

## for debugging

## Expect True
# print test_overlap(peaks, "chr19", chr2row, chr2lastrow, 40348300, 40348800)
# print test_overlap(peaks, "chr19", chr2row, chr2lastrow, 40348900, 42396800)

## Expect False

# print test_overlap(peaks, "chr1", chr2row, chr2lastrow, 0, 100)


	





