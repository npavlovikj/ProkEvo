#!/bin/bash

grep "FAIL" $1 | cut -f 2 | sort | uniq -c >> $2
