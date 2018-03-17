#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=test
#SBATCH --time=1:0:0
#SBATCH --partition=lrgmem
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=xfeng17@jhu.edu

source activate ~/data/xfeng17/miniconda

DATA_DIR=~/code/predict_dnase/12-test
PWM=~/data/xfeng17/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt
PWM_IDS=~/code/predict_dnase/human_pwm_ids_sorted.txt 
REF_FA=~/data/xfeng17/ref_genome/hs/hg38.fa
REF_IDX=~/data/xfeng17/ref_genome/hs/hg38.fa.fai
OUT_DIR=~/code/predict_dnase/12-test_out

12-batch.sh $DATA_DIR $PWM $PWM_IDS $REF_FA $REF_IDX $OUT_DIR

if [ $? -eq 0 ]; then
  echo
  echo "Done!"
else
  echo "Error while running 12-batch.sh"
fi

exit 0
