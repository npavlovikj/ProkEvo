#!/bin/bash

# Load HCC modules
. /util/opt/lmod/lmod/init/profile
export -f module
module use /util/opt/hcc-modules/Common/

module load plasmidfinder/2.0

file=$1
output=$2

mkdir $output
plasmidfinder.py -p $PLASMID_DB -i $file -o $output
tar -czvf ${output}.tar.gz ${output}
