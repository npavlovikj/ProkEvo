#!/bin/bash

set -e

srr_id=$1

rm -rf ${srr_id}_quast_output
mkdir -p ${srr_id}_quast_output
touch ${srr_id}_quast_output/transposed_report.tsv

export PATH=/opt/anaconda/bin:$PATH && quast --fast -o ${srr_id}_quast_output ${srr_id}_contigs.fasta || true  # true is because Quast gives exit code=-1 for contigs with low quality


# in case transposed_report.tsv doesn't exist and is empty
if [ -f ${srr_id}_quast_output/transposed_report.tsv ]
then
  echo "File exists"
  if [ -s ${srr_id}_quast_output/transposed_report.tsv ]
  then
    echo "File not empty"
  else
    echo "File empty"
    echo "EMPTY" > ${srr_id}_quast_output/transposed_report.tsv
  fi
else
  echo "File $srr_id doesn't exist"
  touch ${srr_id}_quast_output/transposed_report.tsv
  echo "EMPTY" > ${srr_id}_quast_output/transposed_report.tsv
fi

cp ${srr_id}_quast_output/transposed_report.tsv ${srr_id}_transposed_report.tsv
