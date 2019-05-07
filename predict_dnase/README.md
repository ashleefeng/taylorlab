# Predicting chromatin accessibility from transcription factor binding motifs

by X. A. Feng

Last updated on May 6, 2019

A supervised learning pipeline that generates a logistic regression or random forest binary classifier to predict chromatin accessibility. The model is trained using experimentally measured open chromatin sites (.bed files), randomly sampled non-open chromatin sites and the presence of known transcription factor position weight matrices.

Here is walk-through to train a GM12878 chromatin accessiblity classifier:

## Download data

### Open chromatin regions

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

Before you start, make sure you have `bedtools`, `fimo` installed. Python packages required can be found at `required_modules.txt`.

```sh
cd ..
export PATH=$PATH:$(pwd) # add the scripts to path 
./10-bed2mat.sh -i hg38.fa.fai -r hg38.fa -m 20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt -d human_pwm_ids_sorted.txt data/ENCFF598KWZ.bed out
```

## Train a logistic regression classifier

```sh
N_TRUE="`wc -l < "out/ENCFF598KWZ_peaks_matrix.tsv"`"
./11-classifier2.py -r out/ENCFF598KWZ_all_matrix.tsv $N_TRUE human_pwm_ids_sorted.txt lr out/ENCFF598KWZ_lr_results
```
