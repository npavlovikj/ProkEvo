#!/bin/bash

a=`awk -F"\t" '{print $14}' $1 | tail -n 1`
b=`awk -F"\t" '{print $17}' $1 | tail -n 1`

if [ $a == 0 ] || [ $a -ge 300 ] || [ $b -le 25000 ]
then
echo "ignore"
else
cp $2 $3/$4_contigs.fasta
fi
