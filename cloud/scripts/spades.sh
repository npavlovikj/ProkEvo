#!/bin/bash

set -o pipefail

check_files(){
  # in case contigs doesn't exist and is empty
  if [ -f $output/contigs.fasta ]
  then
    echo "File exists"
    if [ -s $output/contigs.fasta ]
    then
      echo "File not empty"
    else
      echo "File empty"
      echo ">EMPTY" >> $output/contigs.fasta
      echo "NNNNN" >> $output/contigs.fasta
    fi
  else
    echo "File $srr_id doesn't exist"
    touch $output/contigs.fasta
    echo ">EMPTY" > $output/contigs.fasta
    echo "NNNNN" >> $output/contigs.fasta
  fi
}

source /opt/conda/etc/profile.d/conda.sh
conda activate ProkEvo_dir/prokevo

rm -rf $3
mkdir -p $3
touch $3/contigs.fasta

# spades.py "$@"
spades.py -t 1 -1 $1 -2 $2 \
     --careful --cov-cutoff auto -o $3 --phred-offset 33 | tee spades-output.txt


# Spades gives different error codes that needs to be handled respectively
ec=$? 
output=$3

if [ "$ec" = 1 ]
then
if (grep "err code: -6" spades-output.txt) >/dev/null 2>&1
then
echo "WARNING: spades exited with -6. Changing exit code to 0." 
ec=0
# create 0-byte file
touch $output/contigs.fasta
check_files
elif (grep "err code: -11" spades-output.txt) >/dev/null 2>&1
then
echo "WARNING: spades exited with -11. Changing exit code to 0." 
ec=0
# create 0-byte file
touch $output/contigs.fasta
check_files
elif (grep "err code: -9" spades-output.txt) >/dev/null 2>&1
then
echo "WARNING: spades exited with -9. Changing exit code to 0." 
ec=0
# create 0-byte file
touch $output/contigs.fasta
check_files
elif (grep "err code: 255" spades-output.txt) >/dev/null 2>&1
then
echo "WARNING: spades exited with -255. Changing exit code to 0." 
ec=0
# create 0-byte file
touch $output/contigs.fasta
check_files
fi
else
echo "Exit code is 0"
touch $output/contigs.fasta
check_files
fi

rm spades-output.txt

exit $ec

conda deactivate
