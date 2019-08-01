#!/usr/bin/env bash

usage() {
	cat <<__EOF__

Run 10-bed2mat2.sh and 11-classifier2.py in batch.
by X. Feng Aug 1, 2019

Usage: $0 <data_dir> <pwm.txt> <pwm_ids.txt> <ref.fa> <ref.fa.fai> <transcripts.gtf> <out_dir>

__EOF__
  exit 2
}

# PWM_FILE='~/taylor/rotation/data/pwm/20180217_JASPAR2018_combined_matrices_31015_meme_human_537_TFs.txt'

NUM_EXP_ARGS=7
E_WRONG_ARGS=85

if [ $# -ne $NUM_EXP_ARGS ]; then
	echo -e "Error: Wrong number of arguments."
	usage 
fi

DATA_DIR=$1
PWM_FILE=$2
PWM_IDS=$3
REF_FA=$4
REF_IDX=$5
GTF_FILE=$6
OUT_DIR=$7


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
require_exes 10-bed2mat2.sh 11-classifier2.py

FILENAME="*.bed"

echo "Constructing matrices for file..."

for file in $DATA_DIR/$FILENAME; do

	( 
		echo $file 

		10-bed2mat2.sh -i $REF_IDX -r $REF_FA -m $PWM_FILE -d $PWM_IDS -g $GTF_FILE $file $OUT_DIR

		if [ "$?" != "0" ]; then
			echo -e "Error when running 10-bed2mat2.sh on $file."
			exit -1
		fi 

		BED_BASE=`basename $file .bed`
		FILE_PREFIX="${OUT_DIR}/${BED_BASE}"
		MATRIX_FILE="${FILE_PREFIX}_all_matrix.tsv"
		N_TRUE="`wc -l < "${FILE_PREFIX}_peaks_matrix.tsv"`"
		MOTIF_LIST=$PWM_IDS
		CLF='lr'
		OUT_PREFIX="${FILE_PREFIX}_$CLF"

		11-classifier2.py -r $MATRIX_FILE $N_TRUE $MOTIF_LIST $CLF $OUT_PREFIX

		if [ "$?" != "0" ]; then
			echo -e "Error when running 11-classifier2.py (lr) on $file."
			exit -1
		fi 

		echo
		echo "Done with classification for $file!"

	) &

done
wait


exit 0
