#!/bin/bash

module load anaconda
conda activate prokevo

# abricate "$@"
abricate --db $1 --csv $2

conda deactivate
