#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=cell
#SBATCH --time=10:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

cd ~/data/xfeng17/dnase/hs/differentiated
xargs -n 1 curl -O -L < encode_differentiated_bed.txt

cd ../es
xargs -n 1 curl -O -L < encode_es_bed.txt

cd ../ips
xargs -n 1 curl -O -L < encode_ipsc_bed.txt

cd ../primary
xargs -n 1 curl -O -L < encode_primary_bed.txt 

exit 0
