#!/bin/bash

set -e

export PATH=/opt/anaconda/bin:$PATH && /opt/anaconda/bin/sistr "$@"
