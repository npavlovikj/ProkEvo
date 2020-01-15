#!/bin/bash

# Load HCC modules
. /util/opt/lmod/lmod/init/profile
export -f module
module use /util/opt/hcc-modules/Common/

module load spades/py36/3.13

spades.py "$@"
# spades.py -t 1 -1 $file1 -2 $file2 --careful --cov-cutoff auto -o $out --phred-offset 33
