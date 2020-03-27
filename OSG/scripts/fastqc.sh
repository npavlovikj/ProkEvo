#!/bin/bash

set -e

srr_id=$1

export JAVA_HEAPMIN="256"
export JAVA_HEAPMAX="5000"
export JAVA_OPTS="-Xms256m -Xmx5G"

/opt/anaconda/bin/perl /opt/anaconda/bin/fastqc ${srr_id}_pair_1_trimmed.fastq ${srr_id}_pair_2_trimmed.fastq --extract -j /opt/anaconda/bin/java

cp ${srr_id}_pair_1_trimmed_fastqc/summary.txt ${srr_id}_pair_1_summary.txt
cp ${srr_id}_pair_2_trimmed_fastqc/summary.txt ${srr_id}_pair_2_summary.txt

rm -rf ${srr_id}_pair_1_trimmed_fastqc
rm -rf ${srr_id}_pair_2_trimmed_fastqc
