#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=AF
#SBATCH --time=4:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

source activate ~/data/xfeng17/miniconda
module load perl/5.22.1

export PATH=$PATH:~/code/dnase_pipeline/dnanexus/dnase-call-hotspots/resources/usr/bin/

echo "Running dnase_hotspot.sh on hs alignments..."

cd /home-4/xfeng17@jhu.edu/data/xfeng17/ref_genome/hs

dnase_hotspot.sh ~/data/xfeng17/dnase/hs/A549/ENCFF332VRZ_trimmed_filtered.bam \
chrom_sizes.bed \
hg38_bwa_index.tgz \
hotspot peaks density \
> ENCFF332VRZ_trimmed_filtered_hotspot.log

echo "Done!"
