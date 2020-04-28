#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=f2m
#SBATCH --time=5:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

source activate ~/data/xfeng17/miniconda

cd ~/code/predict_dnase/

echo "Converting rep5 matrix..."

./02-matrix_constructor.py ~/data/xfeng17/dnase/hs/A549/processed/noNNN/ENCFF045PYX_nonpeaks_noNNN.bed ~/data/xfeng17/dnase/hs/A549/processed/noNNN/ENCFF045PYX_rep5_nonpeaks_noNNN_fimo.txt human_pwm_ids_sorted.txt training_data/A549/ENCFF045PYX_rep5_nonpeaks_noNNN_matrix

echo "Converting rep4 matrx..."

./02-matrix_constructor.py ~/data/xfeng17/dnase/hs/A549/processed/noNNN/ENCFF079DJV_nonpeaks_noNNN.bed ~/data/xfeng17/dnase/hs/A549/processed/noNNN/ENCFF079DJV_rep4_nonpeaks_noNNN_fimo.txt human_pwm_ids_sorted.txt training_data/A549/ENCFF079DJV_rep4_nonpeaks_noNNN_matrix

echo "Converting rep3 matrix..."

./02-matrix_constructor.py ~/data/xfeng17/dnase/hs/A549/processed/noNNN/ENCFF698UAH_nonpeaks_noNNN.bed ~/data/xfeng17/dnase/hs/A549/processed/noNNN/ENCFF698UAH_rep3_nonpeaks_noNNN_fimo.txt human_pwm_ids_sorted.txt training_data/A549/ENCFF698UAH_rep3_nonpeaks_noNNN_matrix

echo "Converting rep2 matrix..."

./02-matrix_constructor.py ~/data/xfeng17/dnase/hs/A549/processed/noNNN/ENCFF135JRM_nonpeaks_noNNN.bed ~/data/xfeng17/dnase/hs/A549/processed/noNNN/ENCFF135JRM_rep2_nonpeaks_noNNN_fimo.txt human_pwm_ids_sorted.txt training_data/A549/ENCFF135JRM_rep2_nonpeaks_noNNN_matrix

echo "Done!"

