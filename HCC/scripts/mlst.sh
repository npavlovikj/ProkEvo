#!/bin/bash

# Load HCC modules
. /util/opt/lmod/lmod/init/profile
export -f module
module use /util/opt/hcc-modules/Common/

module load mlst/2.16

export PERL5LIB=/util/opt/anaconda/deployed-conda-envs/packages/mlst/envs/mlst-2.16.2/lib/5.26.2/:/util/opt/anaconda/deployed-conda-envs/packages/mlst/envs/mlst-2.16.2/lib/site_perl/5.26.2:$PERL5LIB

mlst "$@"
# mlst --legacy --scheme senterica --csv *contigs.fasta
