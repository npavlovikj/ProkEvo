#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate ProkEvo_dir/prokevo

# prokka "$@"
prokka --kingdom Bacteria --locustag $1 --outdir $2 --prefix $1 --force $3
tar -czvf $2.tar.gz $2

conda deactivate
