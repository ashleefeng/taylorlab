#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=align_A549_dnase
#SBATCH --time=5:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8

source activate ~/data/xfeng17/miniconda

cd ~/data/xfeng17/ref_genome/dm

~/scratch/dnase_pipeline/dnanexus/dnase-align-bwa-se/resources/usr/bin/dnase_align_bwa_se.sh dm6_bwa_index.tgz ~/data/xfeng17/dnase/dm/oregon/ENCFF005BHD.fastq.gz 8 ~/data/xfeng17/dnase/dm/oregon/ENCFF005BHD 
