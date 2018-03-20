#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=liq
#SBATCH --time=2:0:0
#SBATCH --partition=lrgmem
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=xfeng17@jhu.edu

source activate ~/data/xfeng17/miniconda

DATA_DIR=~/scratch/data/liq_test
PWM=~/scratch/data/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt
PWM_IDS=~/scratch/taylor_lab/predict_dnase/human_pwm_ids_sorted.txt 
REF_FA=~/scratch/data/ref_genome/hg38.fa
REF_IDX=~/scratch/data/ref_genome/hg38.fa.fai
OUT_DIR=~/scratch/data/12-test_liq_out
OUT_FIMO=~/scratch/data/liq_test/ENCFF718KGA_peaks_sorted_fimo.txt
FASTA_FILE=~/scratch/data/liq_test/ENCFF718KGA_peaks_sorted.fasta

motif_liquidator $PWM $FASTA_FILE -o $OUT_FIMO

if [ $? -eq 0 ]; then
  echo
  echo "Done!"
else
  echo "Error while running motif_liquidator"

fi

exit 0
