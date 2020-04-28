#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=tss_qc
#SBATCH --time=3:0:0
#SBATCH --partition=lrgmem
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=xfeng17@jhu.edu

source activate ~/data/xfeng17/miniconda

PWM=~/code/predict_dnase/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt
PWM_IDS=~/code/predict_dnase/human_pwm_ids_sorted.txt 
REF_IDX=~/code/predict_dnase/hg38.fa.fai
GTF=~/data/xfeng17/dnase/hs/tss/gencode.v29.annotation.transcripts.gtf
OUT_DIR=~/code/predict_dnase/tss_test6
PEAKS_FILE_1=~/dnase/hs/encode_pool/K562_rep1.bed
PEAKS_FILE_2=~/dnase/hs/encode_pool/ENCFF342EGB.bed

export PATH=$PATH:~/code/predict_dnase/


00-random_sampler2.py $PEAKS_FILE_1 $REF_IDX $GTF $OUT_DIR 

00-random_sampler2.py $PEAKS_FILE_2 $REF_IDX $GTF $OUT_DIR 

if [ $? -eq 0 ]; then
  echo
  echo "Done!"
else
  echo "Error while running 00-random_sampler2.py"
fi

exit 0
