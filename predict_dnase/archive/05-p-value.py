#! /usr/bin/env python

import matplotlib.pyplot as plt

file = open('/Users/cmdb/taylor/rotation/data/dnase/hs/K562/rep1/ENCFF917OKK.bed')

pvalues = []

for line in file:
	cols = line.rstrip('\n').split('\t')
	p = float(cols[6])
	pvalues.append(p)


plt.figure()
plt.hist(pvalues)
plt.show()