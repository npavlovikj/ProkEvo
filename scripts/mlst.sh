#!/bin/bash

# Load HCC modules
# . /util/opt/lmod/lmod/init/profile
# export -f module
# module use /util/opt/hcc-modules/Common/
# module load anaconda
conda activate ProkEvo_dir/prokevo

# mlst "$@"
# Change scheme based on organism
mlst --legacy --scheme senterica --csv "$@"

conda deactivate
