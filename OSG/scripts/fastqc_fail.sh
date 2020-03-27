#!/bin/bash

set -e

touch $2

grep "FAIL" $1 | cut -f 2 | sort | uniq -c >> $2
echo "FINISH in case transferring empty file" >> $2

# remove all summary files
rm -f *_pair_1_summary.txt
rm -f *_pair_2_summary.txt
