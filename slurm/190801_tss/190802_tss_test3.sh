#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=tss_test3
#SBATCH --time=10:0:0
#SBATCH --partition=lrgmem
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=xfeng17@jhu.edu

source activate ~/data/xfeng17/miniconda

DATA_DIR=~/code/predict_dnase/tss_test3
PWM=~/code/predict_dnase/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt
PWM_IDS=~/code/predict_dnase/human_pwm_ids_sorted.txt 
REF_FA=~/data/xfeng17/ref_genome/hs/hg38.fa
REF_IDX=~/code/predict_dnase/hg38.fa.fai
GTF=~/data/xfeng17/dnase/hs/tss/gencode.v29.annotation.transcripts.gtf
OUT_DIR=~/code/predict_dnase/tss_test3

export PATH=$PATH:~/code/predict_dnase/

time 12-batch2.sh $DATA_DIR $PWM $PWM_IDS $REF_FA $REF_IDX $GTF $OUT_DIR

if [ $? -eq 0 ]; then
  echo
  echo "Done!"
else
  echo "Error while running 12-batch2.sh"
fi

exit 0
