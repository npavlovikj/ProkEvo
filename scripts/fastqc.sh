#!/bin/bash

module load anaconda
conda activate prokevo

# fastqc "$@"
fastqc $1 $2 --extract

conda deactivate
