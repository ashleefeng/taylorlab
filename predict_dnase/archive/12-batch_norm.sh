#!/usr/bin/env bash

usage() {
	cat <<__EOF__

Run 11-classifier.py in batch.
by Xinyu Feng, March 16 2018

Usage: $0 <data_dir> <pwm.txt> <pwm_ids.txt> <ref.fa> <ref.fa.fai> <out_dir>

__EOF__
  exit 2
}

# PWM_FILE='~/taylor/rotation/data/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt'

NUM_EXP_ARGS=6
E_WRONG_ARGS=85

if [ $# -ne $NUM_EXP_ARGS ]; then
	usage 
fi

DATA_DIR=$1
PWM_FILE=$2
PWM_IDS=$3
REF_FA=$4
REF_IDX=$5
OUT_DIR=$6


echo "Checking system for required executables..."
# from hotspot2.sh
require_exes() {
  for x in "$@"; do
    if ! which "$x" &>/dev/null; then
      echo "Could not find $x!"
      exit -1
    fi
  done
}
require_exes 11-classifier.py

FILENAME="*.bed"

for file in $DATA_DIR/$FILENAME; do

	( 
		echo $file 

		BED_BASE=`basename $file .bed`
		FILE_PREFIX="${OUT_DIR}/${BED_BASE}"
		MATRIX_FILE="${FILE_PREFIX}_all_matrix.tsv"
		N_TRUE="`wc -l < "${FILE_PREFIX}_peaks_matrix.tsv"`"
		MOTIF_LIST=$PWM_IDS
		CLF='lr'
		OUT_PREFIX="${FILE_PREFIX}_${CLF}_norm"

		11-classifier.py -r $MATRIX_FILE $N_TRUE $MOTIF_LIST $CLF $OUT_PREFIX

		if [ "$?" != "0" ]; then
			echo -e "Error when running 11-classifier.py (lr) on $file."
			exit -1
		fi 

		echo
		echo "Done with re-classification for $file!"

	) &

done
wait


exit 0
