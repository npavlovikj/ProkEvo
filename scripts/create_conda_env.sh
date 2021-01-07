#!/bin/bash

# Load HCC modules
# . /util/opt/lmod/lmod/init/profile
# export -f module
# module use /util/opt/hcc-modules/Common/
# module load anaconda

# Create conda environment used for all dependencies
conda env create -f $1 -p ProkEvo_dir/prokevo
