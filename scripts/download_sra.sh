#!/bin/bash

module load anaconda
conda activate prokevo

export OMP_NUM_THREADS=1
prefetch $1 && parallel-fastq-dump --sra-id $1 --threads 1 --split-3

# delete prefetch directory
rm -rf $1

conda deactivate
