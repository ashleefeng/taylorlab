#!/usr/bin/env python

import sys
import pandas as pd
import numpy as np 

if len(sys.argv) == 1:
	print "Usage: ./08-venn.py <one.tsv> <two.tsv> ... < lr | rf > <fraction>"
	quit()

assert (sys.argv[-2] == 'lr' or sys.argv[-2] == 'rf'), "Wrong argument"

rank_list = []
lr = 0
fraction = float(sys.argv[-1])

for arg in sys.argv[1:-2]:

	is_avg = 0
	file = open(arg)
	for line in file:
		if line[0:2] != "MA":
			is_avg = 1
		break
	file.close()

	if is_avg:
		rank_file = pd.read_csv(arg, sep='\t')
		rank_file.sort_values('mean', inplace=True, ascending=False)
		rank_list.append(rank_file[['0', '1', 'mean']])
	else:
		rank_file = pd.read_csv(arg, sep='\t', header=None)
		rank_list.append(rank_file)

if sys.argv[-2] == 'lr':
	lr = 1
elif sys.argv[-2] == 'rf':
	lr = 0

id2name = {}

for index, row in rank_file.iterrows():
	id2name[row[0]] = row[1]

# print id2name
id2stats = {}

def id2stats_add(id2stats, motif_id, motif_name, score):
	if motif_id not in id2stats:
		id2stats[motif_id] = [motif_name, 1, score, 0]
	else:
		id2stats[motif_id][1] += 1
		id2stats[motif_id][2] += score

	return None

# top_sets = []

for i in range(len(rank_list)):
	# iset = set()
	rank = rank_list[i]

	if lr == 1:
		top50 = rank.iloc[:50]
		bot50 = rank.iloc[-50:]

		for index, j in top50.iterrows():
			# iset.add(j[0])
			id2stats_add(id2stats, j[0], j[1], j[2])

		for index, k in bot50.iterrows():
			# iset.add(k[0])
			id2stats_add(id2stats, k[0], k[1], k[2])
	else:
		top100 = rank.iloc[:100]

		for index, j in top100.iterrows():
			# iset.add(j[0])
			id2stats_add(id2stats, j[0], j[1], j[2])

	# top_sets.append(iset)

# common = top_sets[0]

# for jset in top_sets[1:]:
	# common = common.intersection(jset)

# print common
# print "Found %d common factors" %len(common)

# common_names = []
# for i in common:
# 	common_names.append(id2name[i])

# print common_names

id2stats_df = pd.DataFrame.from_dict(id2stats, orient='index')

# print id2stats_df.head()
for i in range(id2stats_df.shape[0]):

	id2stats_df.iloc[i, 3] = id2stats_df.iloc[i, 2] / id2stats_df.iloc[i, 1]

min_count = int(np.ceil(len(rank_list) * fraction))
id2stats_sorted = id2stats_df.sort_values([1, 3], ascending=False)

# print "Shared in %d%% (%d) of all cell types:" %(int(fraction*100), min_count)

for index, row in id2stats_sorted.iterrows():
	# for pionneers
	if row[1] < min_count:
		break
	# for nonpioneers
	# if row[1] > min_count:
	# 	continue
	motif_id = index
	motif_name = row[0]
	count = row[1]
	score = row[3]
	print "%s\t%s\t%d\t%.4f" %(motif_id, motif_name, count, score)

