#!/bin/bash

# Load HCC modules
. /util/opt/lmod/lmod/init/profile
export -f module
module use /util/opt/hcc-modules/Common/

export OMP_NUM_THREADS=8

# We use parallel-fastq-dump instead of SRAtoolkit fastq-dump because it is faster and gives less intermittent NCBI errors
module load parallel-fastq-dump/0.6

export PERL5LIB=/util/opt/anaconda/deployed-conda-envs//packages/parallel-fastq-dump/envs/parallel-fastq-dump-0.6.5/lib/site_perl/5.26.2/:/util/opt/anaconda/deployed-conda-envs/packages/parallel-fastq-dump/envs/parallel-fastq-dump-0.6.5/lib/5.26.2/:/util/opt/anaconda/deployed-conda-envs/packages/parallel-fastq-dump/envs/parallel-fastq-dump-0.6.5/lib/site_perl/5.26.2/x86_64-linux-thread-multi/:$PERL5LIB

prefetch $1 && parallel-fastq-dump --sra-id $1 --threads 8 --split-3

# delete prefetch directory
rm -rf $1
