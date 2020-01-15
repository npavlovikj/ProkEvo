#!/bin/bash

# Load HCC modules
. /util/opt/lmod/lmod/init/profile
export -f module
module use /util/opt/hcc-modules/Common/

module load quast/5.0

quast "$@"
# quast --fast -o output contigs.fasta
