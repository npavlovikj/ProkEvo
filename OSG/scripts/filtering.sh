#!/bin/bash

set -e

QUAST="$1"
SPADES_FILE="$2"
NEW_NAME="$3"

START_DIR=`pwd`

a=`awk -F"\t" '{print $14}' $QUAST | tail -n 1`
b=`awk -F"\t" '{print $17}' $QUAST | tail -n 1`

if [ $a == 0 ] || [ $a -ge 300 ] || [ $b -le 25000 ]
then
# empty file
touch $NEW_NAME
echo ">EMPTY" >> $NEW_NAME
echo "NNNNN" >> $NEW_NAME
else
cp $SPADES_FILE $NEW_NAME
fi
