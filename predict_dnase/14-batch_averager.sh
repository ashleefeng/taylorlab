#! /usr/bin/env bash

usage() {
	cat <<__EOF__

Average feature ranks for replicates in batch. Currently only support 2 replicates.
by Xinyu Feng, April 21 2018

Usage: $0 <id2type.tsv> <dir> <suffix(_lr_ranks)>

__EOF__
  exit 2
}

NUM_EXP_ARGS=3
E_WRONG_ARGS=85

if [ $# -ne $NUM_EXP_ARGS ]; then
	usage 
fi

ID2TYPE=$1
DIR=$2
SUF=$3

PREV_ID=''
PREV_TYPE=''
PREV_REP=''
PREV_SAVED=1

set -x

while IFS='' read -r line || [[ -n "$line" ]]; do

	IFS=$'\t' read -ra TOKENS <<< "$line"
	ID=${TOKENS[0]}
	TYPE=${TOKENS[1]}
	REP=${TOKENS[2]}

	RANK="${DIR}/${ID}${SUF}.tsv"
	PREV_RANK="${DIR}/${PREV_ID}${SUF}.tsv"

	if [ -f $RANK ]; then

		if [[ "$REP" == 2 ]]; then
			echo $PREV_TYPE
			echo $TYPE
			echo
			
			OUT_PREFIX="${DIR}/${TYPE}"
			04-average_coeff.py $RANK $PREV_RANK $OUT_PREFIX
			PREV_SAVED=1
			
		elif [[ -f $PREV_RANK && $PREV_SAVED -eq 0 ]]; then
			PREV_RANK_OUT="${DIR}/${PREV_TYPE}${SUF}.tsv"
			cp $PREV_RANK $PREV_RANK_OUT
			PREV_SAVED=0
		else
			PREV_SAVED=0
		fi
		
		PREV_ID=$ID
		PREV_TYPE=$TYPE

	fi	

done < $ID2TYPE

if [ $PREV_SAVED -eq 0 ]; then
	PREV_RANK="${DIR}/${PREV_ID}${SUF}.tsv"
	PREV_RANK_OUT="${DIR}/${PREV_TYPE}${SUF}.tsv"
	cp $PREV_RANK $PREV_RANK_OUT
fi

set +x

exit 0

