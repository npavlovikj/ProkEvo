#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate ProkEvo_dir/prokevo

# sistr "$@"
sistr --qc -vv --alleles-output $1 --novel-alleles $2 --cgmlst-profiles $3 \
    -f csv -o $4 $5

conda deactivate
