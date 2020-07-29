#/usr/bin/env bash

usage() {
	cat <<__EOF__

Average feature ranks for replicates in batch. Currently only support 2 replicates.
by Xinyu Feng, April 22 2018

Usage: $0 <id2type.tsv> <data_dir> <suffix(_lr_ranks)> <out_dir>

__EOF__
  exit 2
}

NUM_EXP_ARGS=4
E_WRONG_ARGS=85

if [ $# -ne $NUM_EXP_ARGS ]; then
	usage 
fi

ID2TYPE=$1
DIR=$2
SUF=$3
OUTDIR=$4

PREV_ID=''
PREV_TYPE=''
PREV_REP=''
PREV_SAVED=1

if [ ! -d $OUTDIR ]; then
	mkdir $OUTDIR
fi

# set -x # for debugging

while IFS='' read -r line || [[ -n "$line" ]]; do

	IFS=$'\t' read -ra TOKENS <<< "$line"
	ID=${TOKENS[0]}
	TYPE=${TOKENS[1]}
	REP=${TOKENS[2]}

	RANK="${DIR}/${ID}${SUF}.tsv"
	PREV_RANK="${DIR}/${PREV_ID}${SUF}.tsv"

	if [ -f $RANK ]; then

		# average replicates
		if [[ "$REP" == 2 ]]; then
			echo $PREV_TYPE
			echo $TYPE
			
			OUT_PREFIX="${OUTDIR}/${TYPE}${SUF}"
			04-average_coeff.py $RANK $PREV_RANK $OUT_PREFIX
			PREV_SAVED=1

			echo
			
		# rename singlets
		elif [[ -f $PREV_RANK && $PREV_SAVED -eq 0 ]]; then
			PREV_RANK_OUT="${OUTDIR}/${PREV_TYPE}${SUF}.tsv"
			cp $PREV_RANK $PREV_RANK_OUT
			PREV_SAVED=0
		else
			PREV_SAVED=0
		fi
		
		PREV_ID=$ID
		PREV_TYPE=$TYPE

	fi	

done < $ID2TYPE

# rename last file if it's singlet
if [ $PREV_SAVED -eq 0 ]; then
	PREV_RANK="${DIR}/${PREV_ID}${SUF}.tsv"
	PREV_RANK_OUT="${OUTDIR}/${PREV_TYPE}${SUF}.tsv"
	cp $PREV_RANK $PREV_RANK_OUT
fi

# set +x

exit 0

