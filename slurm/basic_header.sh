#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=AF
#SBATCH --time=2:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

source activate ~/data/xfeng17/miniconda


