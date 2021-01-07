#!/bin/bash

# Load HCC modules
# . /util/opt/lmod/lmod/init/profile
# export -f module
# module use /util/opt/hcc-modules/Common/
# module load anaconda
conda activate ProkEvo_dir/prokevo

# prokka "$@"
prokka --kingdom Bacteria --locustag $1 --outdir $2 --prefix $1 --force $3
tar -czvf $2.tar.gz $2

conda deactivate
