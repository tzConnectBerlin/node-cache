#!/bin/bash

BLOCKS_DIR=/home/newby/chains/main/blocks
NODE=http://localhost:10734
TOP=$1
TMPFILE=block-tmp-$$.json

set -e

cd $BLOCKS_DIR

if [ -z $TOP ]; then
    HEAD=`curl --silent $NODE/chains/main/blocks/head | jq .header.level`
    echo $HEAD
    TOP=$(($HEAD - 3))
fi
echo $TOP

while [ "$TOP" != "0" ]; do
    CURRENT=$TOP
    TOP=$(($TOP-1))
    if [ -f $TOP.json ]; then
	echo "$TOP was done"
	continue
    fi;
    echo "Caching level $CURRENT"
    wget -q $NODE/chains/main/blocks/$CURRENT -O $TMPFILE
    if jq -e . >/dev/null 2>&1 < $TMPFILE; then
	mv $TMPFILE $CURRENT.json
    else
	echo "Error getting valid JSON for level $CURRENT"
    fi
done
       
    
