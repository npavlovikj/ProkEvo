#!/bin/bash

module load anaconda
conda activate prokevo

# sistr "$@"
sistr --qc -vv --alleles-output $1 --novel-alleles $2 --cgmlst-profiles $3 \
    -f csv -o $4 $5

conda deactivate
