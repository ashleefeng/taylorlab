#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=bt2
#SBATCH --time=7:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16

source activate ~/data/xfeng17/miniconda

#cd ~/data/xfeng17/ref_genome/hs/
#echo "Building index..."

#bowtie2-build --threads 16 hg38.fa hg38 > hg38.bt2.log

cd ~/data/xfeng17/dnase/hs/A549/ 
echo "Aligning to ref genome..."

bowtie2 -t -p 16 -x ~/data/xfeng17/ref_genome/hs/bt2-idx/hg38 -U ENCFF332VRZ.fastq -S ENCFF332VRZ.sam > ENCFF332VRZ.sam.log

echo "Done!"

