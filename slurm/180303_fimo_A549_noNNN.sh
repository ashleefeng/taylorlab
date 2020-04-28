#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=fimoA
#SBATCH --time=8:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

source activate ~/data/xfeng17/miniconda
module load meme

cd /home-4/xfeng17@jhu.edu/data/xfeng17/dnase/hs/A549/processed/noNNN

echo "Running fimo on rep2..."

fimo --text ~/data/xfeng17/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt ENCFF135JRM_nonpeaks_noNNN.fa > ENCFF135JRM_rep2_nonpeaks_noNNN_fimo.txt

echo "Running fimo on rep3..."

fimo --text ~/data/xfeng17/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt ENCFF698UAH_nonpeaks_noNNN.fa > ENCFF698UAH_rep3_nonpeaks_noNNN_fimo.txt

echo "Running fimo on rep4..."

fimo --text ~/data/xfeng17/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt ENCFF079DJV_nonpeaks_noNNN.fa > ENCFF079DJV_rep4_nonpeaks_noNNN_fimo.txt

echo "Running fimo on rep5..."

fimo --text ~/data/xfeng17/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt ENCFF045PYX_nonpeaks_noNNN.fa > ENCFF045PYX_rep5_nonpeaks_noNNN_fimo.txt

echo "Done!"
