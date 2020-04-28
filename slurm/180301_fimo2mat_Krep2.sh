#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=AF
#SBATCH --time=4:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

source activate ~/data/xfeng17/miniconda

cd ~/code/predict_dnase/

#echo "Constructing matrix from peaks fimo output..."

#./02-matrix_constructor.py ~/data/xfeng17/dnase/hs/K563/rep2/ENCFF144PUF_peaks_sorted.bed ~/data/xfeng17/dnase/hs/K563/rep2/ENCFF144PUF_peaks_sorted_fimo.txt human_pwm_ids_sorted.txt ENCFF144PUF_peaks_matrix

echo "Done with peaks. Now doing nonpeaks..."

./02-matrix_constructor.py ~/data/xfeng17/dnase/hs/K563/rep2/ENCFF144PUF_nonpeaks_NNN_rm.bed ~/data/xfeng17/dnase/hs/K563/rep2/ENCFF144PUF_nonpeaks_NNN_rm_fimo.txt human_pwm_ids_sorted.txt ENCFF144PUF_nonpeaks_noNNN_matrix

echo "Done!"
