# Prediction of chromatin accessibility using transcription factor motifs

by X. A. Feng
Last updated on May 6, 2019

A supervised learning pipeline that trains a logistic-regression- or random-forest-based binary classifier to predict chromatin accessibility using experimentally measured open chromatin regions (.bed files), randomly sampled non-open chromatin region and the presence of known transcription factor (TF) motifs as training data.

Here is walkthrough to get a GM12878 chromatin accessiblity classifier:

## Download data

### Open chromatin regions for your cell type of interest

```sh
cd predict_dnase
mkdir data
cd data
wget https://www.encodeproject.org/files/ENCFF598KWZ/@@download/ENCFF598KWZ.bed.gz
gunzip ENCFF598KWZ.bed.gz
```

This is a DNase-seq dataset for GM12878, but in principle any bed narrowpeak files should work.

### Reference genome

```sh
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gunzip hg38.fa.gz
```

## Generate data matrix

Before you start, make sure you have `bedtools`, `fimo` installed.

```sh
cd ..
export PATH=$PATH:$(pwd) # add the scripts to path 
./10-bed2mat.sh -i hg38.fa.fai -r hg38.fa -m 20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt -d human_pwm_ids_sorted.txt data/ENCFF598KWZ.bed out
```







