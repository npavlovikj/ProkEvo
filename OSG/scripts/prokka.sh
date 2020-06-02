#!/bin/bash

set -e

srr_id=$1
output_filtering_contigs=$2

rm -rf ${srr_id}_prokka_output
mkdir -p ${srr_id}_prokka_output
touch ${srr_id}_prokka_output/${srr_id}.gff

export PATH=/opt/anaconda/bin:$PATH && /opt/anaconda/bin/perl /opt/anaconda/bin/prokka --kingdom Bacteria --locustag ${srr_id} --outdir ${srr_id}_prokka_output --prefix ${srr_id} --force ${output_filtering_contigs}

# in case *.gff doesn't exist and is empty
if [ -f ${srr_id}_prokka_output/${srr_id}.gff ]
then
  echo "File exists"
  if [ -s ${srr_id}_prokka_output/${srr_id}.gff ]
  then
    echo "File not empty"
  else
    echo "File empty"
    echo "##gff-version" > ${srr_id}_prokka_output/${srr_id}.gff
  fi
else
  echo "File $srr_id doesn't exist"
  touch ${srr_id}_prokka_output/${srr_id}.gff
  echo "##gff-version" > ${srr_id}_prokka_output/${srr_id}.gff
fi

tar -czvf ${srr_id}_prokka_output.tar.gz ${srr_id}_prokka_output
