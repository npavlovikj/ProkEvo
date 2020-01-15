#!/bin/bash

# Load HCC modules
. /util/opt/lmod/lmod/init/profile
export -f module
module use /util/opt/hcc-modules/Common/

module load prokka/1.13

export PERL5LIB=/util/opt/anaconda/deployed-conda-envs/packages/prokka/envs/prokka-1.13.4/lib/5.26.2/:/util/opt/anaconda/deployed-conda-envs/packages/prokka/envs/prokka-1.13.4/lib/site_perl/5.26.2/:$PERL5LIB

prokka "$@"
# prokka --kingdom Bacteria --locustag $id --outdir $id --prefix $id --force contigs.fasta
