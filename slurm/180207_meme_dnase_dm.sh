#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=meme
#SBATCH --time=5:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8

source activate ~/data/xfeng17/miniconda

module load meme
module load perl

cd /home-4/xfeng17@jhu.edu/data/xfeng17/dnase/dm/thomas/fasta
meme-chip -dna -meme-p 8 bdtnpDnaseAccS9.fa > bdtnpDnaseAccS9_meme.log
 
