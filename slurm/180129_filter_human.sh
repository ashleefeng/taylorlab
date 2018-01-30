#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=filter_human
#SBATCH --time=5:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16

source activate ~/data/xfeng17/miniconda

cd /home-4/xfeng17@jhu.edu/data/xfeng17/dnase/hs/A549/

echo "Filtering human alignments..."

~/data/xfeng17/code/dnase_pipeline/dnanexus/dnase-filter-se/resources/usr/bin/dnase_filter_se.sh \
ENCFF332VRZ_trimmed.bam \
10 \
16 \
ENCFF332VRZ_trimmed_filtered \
> ENCFF332VRZ_trimmed_filtered.log

echo "Done."
