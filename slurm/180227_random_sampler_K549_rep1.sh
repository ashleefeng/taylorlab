#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=rep1
#SBATCH --time=5:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

source activate ~/data/xfeng17/miniconda

cd ~/code/predict_dnase

./00-random_sampler.py ~/data/xfeng17/dnase/hs/K563/rep1/ENCFF917OKK.bed ~/data/xfeng17/ref_genome/hs/hg38.fa.fai > 00-krep1.log
