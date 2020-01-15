#!/bin/bash

set -e

# Load HCC modules
. /util/opt/lmod/lmod/init/profile
export -f module
module use /util/opt/hcc-modules/Common/

module load trimmomatic/0.38

trimmomatic "$@"
# trimmomatic PE -threads 1 $R1 $R2 $R1paired $R1unpaired $R2paired $R2unpaired HEADCROP:15 CROP:200 LEADING:10 TRAILING:10 SLIDINGWINDOW:5:20 MINLEN:50
