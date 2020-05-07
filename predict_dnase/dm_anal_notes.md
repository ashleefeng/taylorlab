# Notes in Dm open chromatin analysis

## Drosophila m. genome

https://hgdownload.cse.ucsc.edu/goldenPath/dm3/bigZips/dm3.fa.gz

## DNaseI Hypersensitive Sites

http://hgdownload.cse.ucsc.edu/goldenPath/dm3/database/bdtnpDnaseAccS5.txt.gz
http://hgdownload.cse.ucsc.edu/goldenPath/dm3/database/bdtnpDnaseAccS9.txt.gz
http://hgdownload.cse.ucsc.edu/goldenPath/dm3/database/bdtnpDnaseAccS10.txt.gz
http://hgdownload.cse.ucsc.edu/goldenPath/dm3/database/bdtnpDnaseAccS11.txt.gz
http://hgdownload.cse.ucsc.edu/goldenPath/dm3/database/bdtnpDnaseAccS14.txt.gz

### Convert to bed files

```
gunzip *.gz
python txt2bed.py
```

`txt2bed.py` removes the first column of from .txt files above

## TF motifs

Dataset 1: JASPAR, 156 D.m. motifs in MEME format

Dataset 2: 145 predicted regulatory motifs from Stark et. al. 2007 Nature paper (https://doi.org/10.1038/nature06340) Supplemental Table S5c Predicted transcription factor motifs.

MEME database (http://meme-suite.org/meme-software/Databases/motifs/motif_databases.12.19.tgz)

Dataset 3: `FLY/fly_factor_survey.meme`  656 motifs, between 5 and 26 in width (average width 10.3).

Dataset 4: `FLY/OnTheFly_2014_Drosophila.meme` 608 motifs, between 4 and 23 in width (average width 9.3).

Start with `OnTheFly_2014_Drosophila.meme` first, since it is pooled from several techniques. Compare with `fly_factor_survey.meme` next, which has similar size but all from B1H. *Might need to get rid of redundant motifs later.*

Use `get_motif_IDs.py` to generate motif ID list.

Annotated OnTheFly motif names, continue from OVO.

## Transcription start sites

Flybase release 5.57 annotations:
   
`dmel-all-no-analysis-r5.57.gff.gz` (ftp://ftp.flybase.net/releases/FB2014_03/dmel_r5.57/gff/dmel-all-no-analysis-r5.57.gff.gz)

Used `predict_dnase/get_transcripts_dm.py` to extract mRNA entries and remove redudant TSS, saved as `~/dm/ref/dmel-all-no-analysis-r5.57.nonredundant-tss.gff`.

## Generate Data Matrices from OntheFly motifs

```
10-bed2mat2.sh -i dm3.fa.fai -r dm3.fa -m ../motifs/OnTheFly_2014_Drosophila.meme -d ../motifs/OnTheFly_2014_Drosophila_motif_IDs.txt -g dmel-all-no-analysis-r5.57.nonredundant-tss.gff ../dhs/bdtnpDnaseAccS5.bed ../out
```
Repeat for S9/S10/S11/S14.bed

`00-random_sampler2.py` was modified to account of Drome specifc details (chromsome names, number)

`02-matrix_constructor.py` was modified to be compatible with fimo output column names.

## Jaspar motifs

```
10-bed2mat2.sh -i dm3.fa.fai -r dm3.fa -m ../motifs/20200428_JASPAR2018_combined_matrices_23595_meme_dm_156_TFs.txt -d ../motifs/JASPAR2018_drome_motif_IDs.txt -g dmel-all-no-analysis-r5.57.nonredundant-tss.gff ../dhs/bdtnpDnaseAccS14.bed ../jaspar_out

Ntrue="`wc -l < "bdtnpDnaseAccS9_peaks_matrix.tsv"`"
11-classifier2.py -r bdtnpDnaseAccS9_all_matrix.tsv $Ntrue ../motifs/JASPAR2018_drome_motif_IDs.txt lr bdtnpDnaseAccS9_lr_results
```

## Train logistic regression classifier

```
Ntrue="`wc -l < "bdtnpDnaseAccS5_peaks_matrix.tsv"`"

11-classifier2.py -r bdtnpDnaseAccS5_all_matrix.tsv $Ntrue ../motifs/OnTheFly_2014_Drosophila_motif_IDs.txt lr bdtnpDnaseAccS5_lr_results
```

## Train random forest classifier

```
11-classifier2.py -r bdtnpDnaseAccS5_all_matrix.tsv $Ntrue ../motifs/OnTheFly_2014_Drosophila_motif_IDs.txt rf bdtnpDnaseAccS5_rf_results
```

Ntrue="`wc -l < "bdtnpDnaseAccS11_peaks_matrix.tsv"`"
11-classifier2.py -r bdtnpDnaseAccS11_all_matrix.tsv $Ntrue ../motifs/JASPAR2018_drome_motif_IDs.txt lr bdtnpDnaseAccS11_lr_results