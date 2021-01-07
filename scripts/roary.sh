#!/bin/bash

# Load HCC modules
# . /util/opt/lmod/lmod/init/profile
# export -f module
# module use /util/opt/hcc-modules/Common/
# module load anaconda
conda activate ProkEvo_dir/prokevo

# roary "$@"
roary -s -e --mafft -p 4 -cd 99.0 -i 95 -f "$@"
tar -czvf roary_output.tar.gz roary_output

conda deactivate
