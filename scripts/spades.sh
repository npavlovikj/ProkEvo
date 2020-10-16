#!/bin/bash

module load anaconda
conda activate prokevo

# spades.py "$@"
spades.py -t 1 -1 $1 -2 $2 \
     --careful --cov-cutoff auto -o $3 --phred-offset 33

conda deactivate
