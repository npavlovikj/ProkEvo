#!/bin/bash

set -e

file=$1
output=$2

export PATH=/opt/anaconda/bin:$PATH

mkdir -p $output
/opt/anaconda/bin/plasmidfinder.py -p /opt/anaconda/share/plasmidfinder-2.0.1-0/database/ -i $file -o $output
tar -czvf ${output}.tar.gz ${output}
