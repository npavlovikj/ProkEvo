#!/bin/bash

# Load HCC modules
# . /util/opt/lmod/lmod/init/profile
# export -f module
# module use /util/opt/hcc-modules/Common/
# module load anaconda
conda activate ProkEvo_dir/prokevo

cat > fastbaps.R <<EOF
# Load library
library("fastbaps")
args = commandArgs(trailingOnly=TRUE)

# Set seed to reproduce results
set.seed(1234)

sparse.data <- import_fasta_sparse_nt(args[1], prior = "baps")
# levels=1, population=150, cores=1
multi.results <- multi_res_baps(sparse.data, levels = 1, k.init=150, n.cores = 1)
write.csv(multi.results, file = args[2], col.names = TRUE, row.names = FALSE, quote = FALSE)
EOF

Rscript fastbaps.R $1 $2

conda deactivate
