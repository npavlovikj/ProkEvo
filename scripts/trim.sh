#!/bin/bash

set -e

module load anaconda
conda activate prokevo

# trimmomatic "$@"
trimmomatic PE -threads 1 $1 $2 $3 $4 $5 $6 \
    HEADCROP:15 CROP:200 LEADING:10 TRAILING:10 SLIDINGWINDOW:5:20 MINLEN:50

conda deactivate
