#!/bin/bash

set -x

srr_id=$1
output_filtering_contigs=$2

export PATH=/opt/anaconda/bin:$PATH && export CGMLST_CENTROID_FASTA_PATH="/opt/anaconda/lib/python3.6/site-packages/sistr/data/cgmlst/cgmlst-centroid.fasta" && \
export CGMLST_FULL_FASTA_PATH="/opt/anaconda/lib/python3.6/site-packages/sistr/data/cgmlst/cgmlst-full.fasta" && \
export CGMLST_PROFILES_PATH="cgmlst-profiles.hdf" && /opt/anaconda/bin/sistr --qc -vv --alleles-output ${srr_id}_allele_results.json \
    --novel-alleles ${srr_id}_novel_alleles.fasta --cgmlst-profiles ${srr_id}_cgmlst_profiles.csv -f csv \
    -o ${srr_id}_sistr_output.csv ${output_filtering_contigs}
