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
      echo "EMPTY" > $output/contigs.fasta
    fi
  else
    echo "File $srr_id doesn't exist"
    touch $output/contigs.fasta
    echo "EMPTY" > $output/contigs.fasta
  fi
}


file1=$1
file2=$2
output=${3}_spades_output

rm -rf $output
mkdir -p $output
touch $output/contigs.fasta

/opt/anaconda/bin/spades.py -t 4 -1 $file1 -2 $file2 --careful --cov-cutoff auto -o $output --phred-offset 33 | tee spades-output.txt


ec=$? 

if [ "$ec" = 1 ]
then
if (grep "err code: -6" spades-output.txt) >/dev/null 2>&1
then
echo "WARNING: spades exited with -6. Changing exit code to 0." 
ec=0
# create 0-byte file
# rm $output/contigs.fasta
touch $output/contigs.fasta
check_files
cp $output/contigs.fasta ${3}_contigs.fasta
rm -rf $output
elif (grep "err code: -11" spades-output.txt) >/dev/null 2>&1
then
echo "WARNING: spades exited with -11. Changing exit code to 0." 
ec=0
# create 0-byte file
# rm $output/contigs.fasta
touch $output/contigs.fasta
check_files
cp $output/contigs.fasta ${3}_contigs.fasta
rm -rf $output
fi 
else
echo "Exit code is 0"
touch $output/contigs.fasta
check_files
cp $output/contigs.fasta ${3}_contigs.fasta
rm -rf $output
fi

rm spades-output.txt

exit $ec
