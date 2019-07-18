#!/usr/bin/env python

"""
Usage: ./00-random_sampler.py <file.bed> <ref.fasta.fai> <outdir>
Output: outdir/file_peaks_sorted.bed, outidir/file_nonpeaks.bed
X. Feng xfeng17@jhu.edu
July 17, 2019
"""

import sys
from os.path import basename
import pandas as pd
import numpy as np

if len(sys.argv) == 1:
	print("Usage: ./00-random_sampler.py <peaks.bed> <ref.fasta.fai> <outdir>")
	quit()


NUM_CHROM = 23

"""
Randomly sample a region from the genome

input: n2chr: {int: str} -  map from chromosome number to name
       chr2len: {str: int} - map from chromosome name to size
       size: int - size of random region to generate

output: chrom: str - name of chromosome
        start: int - start of random region
        end: int - end of random region
"""
def get_random_region(n2chr, chr2len, size):

	chrom = n2chr[np.random.randint(0, NUM_CHROM)]

	# pick start site
	start = np.random.randint(0, chr2len[chrom] - size)
	end = start + size - 1

	return chrom, start, end

"""
Randomly sample a region from the genome with similar distance to TSS

input: n2chr: {int: str} -  map from chromosome number to name
       chr2len: {str: int} - map from chromosome name to size
       size: int - size of random region to generate
       chr2tss: {str: list(int)} - map from chromosome name to TSS locations

output: chrom: str - name of chromosome
        start: int - start of random region
        end: int - end of random region
"""
def get_random_region_TSS(n2chr, chr2len, size, open2tss_dist, chr2tss):

	chrom = n2chr[np.random.randint(0, NUM_CHROM)]

	# pick tss
	tss_list = chr2tss[chrom]
	tssID = np.random.randint(len(tss_list))
	tss = tss_list(tssID)

	start = tss + open2tss_dist
	end = start + size - 1

	return chrom, start, end

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

	if peaks.iloc[lo-1]["chrom"] != rand_chrom:
		# target is earlier than the first dnase 
		# peak for that chromosome
		return False

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
		# print "Overlap: ", above_end, target_start, target_end, below_start
		return True


# read peaks file and ref genome
bed_file = sys.argv[1]
ref_index_file = sys.argv[2]
outdir = sys.argv[3]

peaks = pd.read_csv(bed_file, sep='\t', header=None, \
	names=["chrom", "start", "end", "name", "score", "strand", "thickStart",\
	"thickEnd", 8, 9])

refidx = pd.read_csv(ref_index_file, '\t', header=None, \
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
missing_chr = set()

for index, row in peaks.iterrows():

	dhs_len = row["end"] - row["start"] + 1
	repick = True

	while repick:

		random_chrom, random_start, random_end = get_random_region(n2chr, chr2len, dhs_len)

		# check if the random region overlaps with DHS
		# if yes, then repick

		try:
			repick = test_overlap(peaks, rand_chrom, chr2row, chr2lastrow, rand_start, rand_end)
		except KeyError:
			if rand_chrom not in missing_chr:
				print("%s file is missing %s" %(bed_file, rand_chrom))
				missing_chr.add(rand_chrom)


	nonpeaks.iloc[counter] = [rand_chrom, rand_start, rand_end]

	counter += 1

	if counter % 10000 == 0:
		print("Done with " + str(counter) + " rows.")


bed_base = basename(bed_file).rstrip(".bed")
nonpeaks.to_csv(outdir + "/" + bed_base + "_nonpeaks_temp.bed", sep='\t', header=False, index=False)
peaks.to_csv(outdir + "/" + bed_base + "_peaks_sorted.bed", sep='\t', header=False, index=False)
