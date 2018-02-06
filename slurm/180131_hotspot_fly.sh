#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=hotspot_fly
#SBATCH --time=4:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

source activate ~/data/xfeng17/miniconda

cd ~/data/xfeng17/ref_genome/dm/

extractCenterSites.sh -c dm_chrom_sizes.bed -o dm6
