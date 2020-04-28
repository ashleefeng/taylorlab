#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=fimokrep1
#SBATCH --time=7:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G

source activate ~/data/xfeng17/miniconda
module load meme

cd /home-4/xfeng17@jhu.edu/data/xfeng17/dnase/hs/K563/rep2

echo "Running fimo..."

fimo --oc peaks_fimo ~/data/xfeng17/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt ENCFF144PUF_peaks_sorted.fa > ENCFF144PUF_peaks_sorted_fimo.log

fimo --oc nonpeaks_fimo ~/data/xfeng17/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt ENCFF144PUF_nonpeaks_NNN_rm.fa > ENCFF144PUF_nonpeaks_NNN_rm_fimo.log

echo "Done!"
