#!/bin/bash

module load anaconda

# Create conda environment used for all dependencies
conda env create -f $1 -p prokevo
