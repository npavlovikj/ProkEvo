#!/bin/bash

# Load HCC modules
. /util/opt/lmod/lmod/init/profile
export -f module
module use /util/opt/hcc-modules/Common/

module load fastqc/0.11

export PERL5LIB=/util/opt/anaconda/deployed-conda-envs/packages/fastqc/envs/fastqc-0.11.7/lib/5.26.2/:$PERL5LIB

fastqc "$@"
# fastqc pair_1_trimmed.fastq pair_2_trimmed.fastq --extract
