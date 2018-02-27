#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=fimo_rep5_nonpeaks
#SBATCH --time=5:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

source activate ~/data/xfeng17/miniconda
module load meme

cd /home-4/xfeng17@jhu.edu/data/xfeng17/dnase/hs/A549/processed/rep5

echo "Running fimo..."

fimo --oc nonpeaks_fimo ~/data/xfeng17/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt ENCFF045PYX_nonpeaks.fa > ENCFF045PYX_nonpeaks_fimo.log

echo "Done!"
