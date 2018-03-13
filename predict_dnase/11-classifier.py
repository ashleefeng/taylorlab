#!/usr/bin/env python

"""
Trains a classifier on the given training set and assesses its performance

Xinyu Feng, March 12 2018

Example usage: ./11-classifier.py -m 10-test/00-test_all_matrix.tsv -t 50 -o 11-test/result -p -l human_pwm_ids_sorted.txt
"""

from sklearn.preprocessing import normalize
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression 
from sklearn.linear_model import LogisticRegressionCV
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score
from sklearn.metrics import roc_curve
from sklearn.metrics import roc_auc_score

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import argparse

"""
Evaluate performance of clf, save results to log file and as figures.

input  clf: trained LogisticRegressionCV or RandomeForest instance
"""
def performance(clf, X_test, y_test, out_prefix, will_plot, log):

	test_score = clf.score(X_test, y_test)
	y_score = clf.predict_proba(X_test)
	auc = roc_auc_score(y_test, y_score[:, 1])

	if will_plot:

		fpr, tpr, thresholds = roc_curve(y_test, y_score[:, 1])
		plt.figure()
		plt.plot(fpr, tpr)
		plt.xlabel("False positive rate")
		plt.ylabel("True positive rate")
		plt.savefig(out_prefix + '_roc.png')
		plt.close()

	if (type(clf) == LogisticRegressionCV):
		log.write("\nLogistic regression classifier:\n\n")
		log.write("optimized C = %.2f\ntest set score = %.2f\nauc = %.2f\n" %(clf.C_, test_score, auc))

	return

""" 
Save pwms ranked by clf parameters.

"""
def save_ranks(ranks, motif_list, out_prefix):

	sort_ids = np.flip(np.argsort(ranks), 1)
	motif_list['rank'] = ranks.T 

	to_save = motif_list.iloc[sort_ids[0], [1, 2, 3]]
	to_save.to_csv(out_prefix + '_ranks.tsv', sep='\t',header=False, index=False)

	return

# Parse arguments

parser = argparse.ArgumentParser(description='Train a chromatin accessibility classifier.')
parser.add_argument('-m', '--matrix' , help="<mat.tsv> matrix of training data")
parser.add_argument('-t', '--true', type=int, help="<int> number of true labels in the matrix")
parser.add_argument('-o', '--out', help="<out_prefix> prefix for output")
parser.add_argument('-p', '--plot', action='store_true')
parser.add_argument('-l', '--motif_list', help="<pwm_ids.txt> names of pwms in the same order as the matrix")

args = vars(parser.parse_args())
matrix_filename = args['matrix']
n_true = args['true']
out_prefix = args['out']
will_plot = args['plot']
motif_list = pd.read_csv(args['motif_list'], sep=' ', header=None)

log = open(out_prefix + '.log', 'w')
log.write('Matrix file: %s\n' %matrix_filename)
log.write('Number of true labels: %d\n' %n_true)

# Loading data 

X = np.loadtxt(matrix_filename, delimiter='\t')
y = np.zeros((X.shape[0],), dtype=np.uint8)
for i in range(n_true):
	y[i] = 1
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.50)

# Train a logistic regression classifier

lr_clf = LogisticRegressionCV(cv=5)
lr_clf.fit(X_train, y_train)

performance(lr_clf, X_test, y_test, out_prefix, will_plot, log, 'lr')
save_ranks(lr_clf.coef_, motif_list, out_prefix)

log.close()
