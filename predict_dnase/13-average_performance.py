#!/usr/bin/env python

import sys
import os
import numpy as np 

path = sys.argv[1]

scores = []
aucs = []


for filename in os.listdir(path):
	file = open(path + filename)
	for i, line in enumerate(file):
		if i == 7:
			score = np.float(line.rstrip('\n').split('=')[1])
		if i == 8:
			auc = np.float(line.rstrip('\n').split('=')[1])

	scores.append(score)
	aucs.append(auc)

print 'Accuracy: %.4f +/- %.4f' %(np.mean(scores), np.std(scores))
print 'AUC: %.4f +/- %.4f' %(np.mean(aucs), np.std(aucs))

