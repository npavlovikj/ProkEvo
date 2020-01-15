#!/bin/bash

# Load HCC modules
. /util/opt/lmod/lmod/init/profile
export -f module
module use /util/opt/hcc-modules/Common/

module load sistr_cmd/1.0

sistr "$@"
# sistr --qc -vv --alleles-output id_allele_results.json --novel-alleles id_novel_alleles.fasta --cgmlst-profiles id_cgmlst_profiles.csv -f csv -o id_sistr_output.csv id_contigs.fasta
