#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh

# Create conda environment used for all dependencies
conda env create -f $1 -p ProkEvo_dir/prokevo
