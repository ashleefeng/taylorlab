#! /usr/bin/env bash

#SBATCH
#SBATCH --job-name=cell
#SBATCH --time=10:0:0
#SBATCH --partition=lrgmem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

cd ~/data/xfeng17/dnase/hs/cell_lines
xargs -n 1 curl -O -L < encode_cell_line_bed.txt

exit 0
