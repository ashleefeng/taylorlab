#! /usr/bin/env python

# Sample N lines from a file

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("N")
parser.add_argument("filename")

args = vars(parser.parse_args())

n = int(args["N"])
filename = args["filename"]

file = open(filename)

total = 0
for line in file:
	total += 1

file.close()

sample_rate = total/n
#print(sample_rate)

if sample_rate == 0:
	print("total/n = 0")
else:

	file = open(filename)

	counter = 0
	for line in file:
		l = line.rstrip('\n')
		if counter % sample_rate == 0:
			print(l)
		elif counter == total-1:
			print(l)
		counter += 1


	file.close()

