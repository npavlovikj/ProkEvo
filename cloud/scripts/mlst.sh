#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate ProkEvo_dir/prokevo

# mlst "$@"
# Change scheme based on organism
mlst --legacy --scheme senterica --csv "$@"

conda deactivate
