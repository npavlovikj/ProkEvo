#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate ProkEvo_dir/prokevo

# abricate "$@"
abricate --db $1 --csv $2

conda deactivate
