#!/bin/bash

module load anaconda
conda activate prokevo

rm -rf $1
mkdir -p $1
touch $1/transposed_report.tsv

# quast "$@"
quast --fast -o $1 $2 || true  # true because Quast gives exit code=-1 for contigs with low quality

# In case transposed_report.tsv doesn't exist and is empty
if [ -f $1/transposed_report.tsv ]
then
  echo "File exists"
  if [ -s $1/transposed_report.tsv ]
  then
    echo "File not empty"
  else
    echo "File empty"
    echo "EMPTY" > $1/transposed_report.tsv
  fi
else
  echo "File doesn't exist"
  touch $1/transposed_report.tsv
  echo "EMPTY" > $1/transposed_report.tsv
fi

conda deactivate
