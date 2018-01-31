#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=qc_fly
#SBATCH --time=5:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16

source activate ~/data/xfeng17/miniconda

code_dir=/home-4/xfeng17@jhu.edu/data/xfeng17/code/dnase_pipeline/dnanexus/dnase-qc-bam/resources/usr/bin

genome_dir=~/data/xfeng17/ref_genome/dm

align_dir=~/data/xfeng17/dnase/dm/oregon

hotspot_dir=/home-4/xfeng17@jhu.edu/data/xfeng17/hotspot

module load R
module load bedtools/2.19.1 
module load gcc/6.4.0

cd $code_dir

./dnase_qc_bam.sh ${align_dir}/ENCFF005BHD_trimmed_filtered.bam \
10059570 16 se dm6 ${genome_dir}/dm6_bwa_index.tgz 36 $hotspot_dir \
> ${align_dir}/ENCFF005BHD_trimmed_filtered_qc.log
