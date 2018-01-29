#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=trim_reads
#SBATCH --time=5:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

source activate ~/data/xfeng17/miniconda

cd ~/data/xfeng17/dnase/dm/oregon

echo "Trimming dm dnase reads"

sickle se -f ENCFF005BHD.fastq -t illumina -o ENCFF005BHD_trimmed.fastq -q 30 > ENCFF005BHD_trim.log

#echo "Trimming human dnase reads"

#cd ../../hs/A549

#gunzip -c ENCFF332VRZ.fastq.gz > ENCFF332VRZ.fastq

#sickle se -f ENCFF332VRZ.fastq -t sanger -o ENCFF332VRZ_trimmed.fastq -q 30 > ENCFF332VRZ_trim.log 
