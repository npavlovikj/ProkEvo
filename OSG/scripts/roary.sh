#!/bin/bash

set -e

export PATH=/opt/anaconda/bin:$PATH && /opt/anaconda/bin/perl /opt/anaconda/bin/roary "$@"

tar -czvf roary_output.tar.gz roary_output
