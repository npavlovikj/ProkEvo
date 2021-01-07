#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate ProkEvo_dir/prokevo

# roary "$@"
roary -s -e --mafft -p 4 -cd 99.0 -i 95 -f "$@"
tar -czvf roary_output.tar.gz roary_output

conda deactivate
