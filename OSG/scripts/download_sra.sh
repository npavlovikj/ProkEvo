#!/bin/bash

# We use parallel-fastq-dump instead of SRAtoolkit fastq-dump because it is faster and gives less intermittent NCBI errors

set -e

srr_id=$1
# export OMP_NUM_THREADS=8

# export PERL5LIB=/opt/anaconda/lib/site_perl/5.26.2/:/opt/anaconda/lib/5.26.2/:/opt/anaconda/lib/site_perl/5.26.2/x86_64-linux-thread-multi/:$PERL5LIB
export PATH=/opt/anaconda/bin/:$PATH
/opt/anaconda/bin/perl /opt/anaconda/bin/prefetch ${srr_id} && /opt/anaconda/bin/perl /opt/anaconda/bin/parallel-fastq-dump --sra-id ${srr_id} --threads 8 --split-3

# delete prefetch directory
rm -rf ${srr_id}
