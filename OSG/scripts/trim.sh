#!/bin/bash

set -e

srr_id=$1

/opt/anaconda/bin/java -Xms256m -Xmx50G -jar /opt/anaconda/share/trimmomatic-0.39-1/trimmomatic.jar PE -threads 1 \
  ${srr_id}_1.fastq ${srr_id}_2.fastq ${srr_id}_pair_1_trimmed.fastq ${srr_id}_unpair_1_trimmed.fastq ${srr_id}_pair_2_trimmed.fastq ${srr_id}_unpair_2_trimmed.fastq \
  HEADCROP:15 CROP:200 LEADING:10 TRAILING:10 SLIDINGWINDOW:5:20 MINLEN:50


# in case _pair doesn't exist
if [ -f ${srr_id}_pair_1_trimmed.fastq ]
then
    echo "File exists"
else
    echo "File $srr_id doesn't exist"
    touch ${srr_id}_pair_1_trimmed.fastq
    echo "EMPTY" > ${srr_id}_pair_1_trimmed.fastq
fi
if [ -f ${srr_id}_pair_2_trimmed.fastq ]
then
    echo "File exists"
else
    echo "File $srr_id doesn't exist"
    touch ${srr_id}_pair_2_trimmed.fastq
    echo "EMPTY" > ${srr_id}_pair_2_trimmed.fastq
fi


# in case _pair is empty
if [ -s ${srr_id}_pair_1_trimmed.fastq ]
then
     echo "File not empty"
else
     echo "File $srr_id empty"
     # echo "EMPTY" > ${srr_id}_pair_1_trimmed.fastq
fi
if [ -s ${srr_id}_pair_2_trimmed.fastq ]
then
     echo "File not empty"
else
     echo "File $srr_id empty"
     # echo "EMPTY" > ${srr_id}_pair_1_trimmed.fastq
fi


# Remove *_unpair_*
#rm -f ${srr_id}_unpair_1_trimmed.fastq
#rm -f ${srr_id}_unpair_2_trimmed.fastq
