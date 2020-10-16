#!/bin/bash

module load anaconda
conda activate prokevo

# quast "$@"
quast --fast -o $1 $2

conda deactivate
