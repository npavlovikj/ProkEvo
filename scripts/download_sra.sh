#!/bin/bash

# Load HCC modules
# . /util/opt/lmod/lmod/init/profile
# export -f module
# module use /util/opt/hcc-modules/Common/
# module load anaconda
conda activate ProkEvo_dir/prokevo

export OMP_NUM_THREADS=1
prefetch $1 && parallel-fastq-dump --sra-id $1 --threads 1 --split-3

# delete prefetch directory
rm -rf $1

conda deactivate
