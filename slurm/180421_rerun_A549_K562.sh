#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=AK
#SBATCH --time=10:0:0
#SBATCH --partition=lrgmem
#SBATCH --ntasks=6
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=xfeng17@jhu.edu

source activate ~/data/xfeng17/miniconda

DATA_DIR=~/data/xfeng17/dnase/hs/A549_and_K562
PWM=~/scratch/data/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt
PWM_IDS=~/scratch/taylor_lab/predict_dnase/human_pwm_ids_sorted.txt 
REF_FA=~/scratch/data/ref_genome/hg38.fa
REF_IDX=~/scratch/data/ref_genome/hg38.fa.fai
OUT_DIR=~/data/xfeng17/dnase/hs/A549_and_K562/batch_liq_out

time 12-batch_liq.sh $DATA_DIR $PWM $PWM_IDS $REF_FA $REF_IDX $OUT_DIR

if [ $? -eq 0 ]; then
  echo
  echo "Done!"
else
  echo "Error while running 12-batch_liq.sh"
fi

exit 0
