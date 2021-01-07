#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate ProkEvo_dir/prokevo

# fastqc "$@"
fastqc $1 $2 --extract

conda deactivate
