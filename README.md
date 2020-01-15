# Running population genomics analysis of bacteria using Pegasus workflow (workflow of workflows) utilizing High Performance Computing (HCC) and High Throughput Computing (OSG).

## Introduction

## Running the workflow on HCC, https://hcc.unl.edu:
To run the worflow on HCC, please clone the repo and type `cd HCC`.
All the analysis are run from the repo directory.
The user needs to do only 2 modifications:
- replace `BacGenPop` in `tc.txt` and `rc.txt` with the absolute path of the current directory
- add the SRA ids in `sra_ids.txt`

## Running the workflow on OSG, https://opensciencegrid.org
To run the workflow on OSG, please clone the repo and type `cd OSG`.
All the analysis are run from the repo directory.
The user needs to do only 2 modifications:
- replace `BacGenPop` in `tc.txt` and `rc.txt` with the absolute path of the current directory
- add the SRA ids in `sra_ids.txt`
