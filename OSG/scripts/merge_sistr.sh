#!/bin/bash

head=`head -n 1 "$1"`
# get only the even rows
awk 'NR%2==0' "$1" > "$2"
sed -i '1i '"${head}"'' "$2"

# lines with FAIL should be removed
sed -i '/FAIL/d' "$2"
