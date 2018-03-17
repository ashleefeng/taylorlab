#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=batch
#SBATCH --time=8:0:0
#SBATCH --partition=lrgmem
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=xfeng17@jhu.edu

source activate ~/data/xfeng17/miniconda

DATA_DIR=~/data/xfeng17/dnase/hs/encode_top24
PWM=~/data/xfeng17/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt
PWM_IDS=~/code/predict_dnase/human_pwm_ids_sorted.txt 
REF_FA=~/data/xfeng17/ref_genome/hs/hg38.fa
REF_IDX=~/data/xfeng17/ref_genome/hs/hg38.fa.fai
OUT_DIR=~/data/xfeng17/dnase/hs/encode_top24/batch_out

12-batch.sh $DATA_DIR $PWM $PWM_IDS $REF_FA $REF_IDX $OUT_DIR

if [ $? -eq 0 ]; then
  echo
  echo "Successfully finished!"
else
  echo "Error while running 12-batch.sh"
fi

exit 0
