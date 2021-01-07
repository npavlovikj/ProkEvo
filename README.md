# ProkEvo: an automated, reproducible, and scalable framework for high-throughput bacterial population genomics analyses
Pavlovikj, N., Gomes-Neto, J. C., Deogun, J. S., & Benson, A. K. (2020). ProkEvo: an automated, reproducible, and scalable framework for high-throughput bacterial population genomics analyses. bioRxiv.

## Overall ProkEvo's computational workflow
<img width="777" alt="Figure 1" src="https://github.com/npavlovikj/ProkEvo/blob/master/figures/Figure1.png">

ProkEvo is: 
1) An automated, user-friendly, reproducible, and open-source platform for bacterial population genomics analyses that uses the Pegasus Workflow Management System; 
2) A platform that can scale the analysis from at least a few to tens of thousands of bacterial genomes using high-performance and high-throughput computational resources; 
3) An easily modifiable and expandable platform that can accommodate additional steps, custom scripts and software, user databases, and species-specific data; 
4) A modular platform that can run many thousands of analyses concurrently, if the resources are available; 
5) A platform for which the memory and run time allocations are specified per job, and automatically increases its memory in the next retry;
6) A platform that is distributed with conda environment and Docker image for all bioinformatics tools and databases needed to perform population genomics analyses. 

To demonstrate versatility of the ProkEvo platform, we performed population-based analyses from available genomes of three distinct pathogenic bacterial species as individual case studies (three serovars of _Salmonella enterica_, as well as _Campylobacter jejuni_ and _Staphylococcus aureus_). 

The specific case studies used reproducible Python and R scripts documented in Jupyter Notebooks and collectively  illustrate how hierarchical analyses of population structures, genotype frequencies, and distribution of specific gene functions can be used to generate novel hypotheses about the evolutionary history and ecological characteristics of specific populations of each pathogen.

The scalability and portability of ProkEvo was measured with two datasets comprising significantly different numbers of input genomes (one with ~2,400 genomes, and the second with ~23,000 genomes) on two different computational platforms, the [University of Nebraska high-performance computing cluster (Crane)](https://hcc.unl.edu) and the [Open Science Grid (OSG), a distributed, high-throughput cluster](https://opensciencegrid.org). Depending on the dataset and the computational platform used, the running time of ProkEvo varied from ~3-26 days.

## NOTE:
ProkEvo is under ongoing development and testing. If you have any questions or issues with ProkEvo and the provided instructions, please let us know. We have limited personnel and resources, and we will try out best to answer any questions when we can. Thank you for your patience and thank you for checking out ProkEvo!


## Quick start
ProkEvo takes advantage of the [Pegasus Workflow Management System (WMS)](https://pegasus.isi.edu) to ensure reproducibility, scalability, modularity, fault-tolerance, and robust file management throughout the process. Pegasus WMS uses [HTCondor](http://research.cs.wisc.edu/htcondor) to submit workflows to various computational platforms, such as University or publicly available clusters, clouds, or distributed grids.

In order to use ProkEvo, the computational platform needs to have HTCondor, Pegasus WMS and Miniconda. While these can be found on the majority computational platforms, instructions for installation can be found [here](https://research.cs.wisc.edu/htcondor/instructions/el/7/stable/), [here](https://pegasus.isi.edu/downloads/) and [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/rpm-debian.html) respectively.

```
[npavlovikj@login.crane ~]$ git clone https://github.com/npavlovikj/ProkEvo.git
[npavlovikj@login.crane ~]$ cd ProkEvo/
```

To download raw Illumina paired-end reads from NCBI, as an input, ProkEvo requires only a list of SRA ids stored in the file `sra_ids.txt`. In this repo, as an example we provide file `sra_ids.txt` with few Salmonella enterica subsp. enterica serovar Enteritidis genomes:
```
[npavlovikj@login.crane ProkEvo]$ cat sra_ids.txt 
SRR5160663
SRR8385633
SRR9984383
```

Once the input files are specified, the next step is to submit ProkEvo using the provided `submit.sh` script:
```
[npavlovikj@login.crane ProkEvo]$ ./submit.sh 
```
And that's it! The submit script sets the current directory as a working directory where all temporary and final outputs are stored. Running `./submit.sh` prints lots of useful information on the command line, including how to check the status of the workflow and remove it if necessary.

Due to differences in the computational platforms, ProkEvo has a different version for OSG and Virtual Cloud Machine. The code for these versions can be found in the sub-directories `OSG` and `cloud` respectively. 

## Installation
The aforementioned instructions allow researchers to give ProkEvo an immediate go. For more detailed instructions on how to use ProkEvo:
- [with downloading raw Illumina reads from NCBI](https://github.com/npavlovikj/ProkEvo/wiki/3.1.-Setup-on-high-performance-computing-cluster#1-downloading-raw-illumina-reads-from-ncbi)
- [with locally downloaded fastq files](https://github.com/npavlovikj/ProkEvo/wiki/3.1.-Setup-on-high-performance-computing-cluster#2-using-already-downloaded-raw-reads)
- [to monitor the workflow](https://github.com/npavlovikj/ProkEvo/wiki/3.1.-Setup-on-high-performance-computing-cluster#monitoring-prokevo)
- [to check the produced output files](https://github.com/npavlovikj/ProkEvo/wiki/3.1.-Setup-on-high-performance-computing-cluster#output)
- [on high-performance computing cluster](https://github.com/npavlovikj/ProkEvo/wiki/3.1.-Setup-on-high-performance-computing-cluster)
- [on virtual cloud machine](https://github.com/npavlovikj/ProkEvo/wiki/3.2.-Setup-on-virtual-cloud-machine)

please check our [Wiki pages](https://github.com/npavlovikj/ProkEvo/wiki).


## Some notes:
- All jobs and dependencies are defined in the files `root-dax.py` and `sub-dax.py`. 
	- `root-dax.py` contains the steps and dependencies from the first sub-workflow, such as downloading raw Illumina sequences from NCBI, performing quality control and de novo assembly, as well as removing low-quality contigs. 
	- `sub-dax.py` contains the steps and dependencies from the second sub-workflow, which is composed of more specific population-genomics analyses, such as genome annotation and pan-genome analyses (with Prokka and Roary), isolate cgMLST classification and serotype predictions from genotypes in the case of Salmonella (SISTR), ST classification using the MLST scheme, non-supervised heuristic Bayesian genotyping approach using core-genome alignment (fastbaps), and identifications of genetic elements with ABRicate and PlasmidFinder.
- The scripts for the tools used and their respective options are stored in the directory `scripts/`, and their absolute path is defined in `tc.txt`.
- If you want to add more tools, please add the scripts for the tool in `scripts/`, and define the necessary job and dependency in `root-dax.py` or `sub-dax.py`.
- To remove a specific tool, such as SISTR for non-Salmonella genomes, please comment out the dependency in `root-dax.py` or `sub-dax.py`.
- To use MLST with different organism, please modify the scheme in `scripts/mlst.sh`.
- You can use raw Illumina sequences stored locally instead of downloading them from NCBI. To do this, you will need to add information about the input files in `rc.txt` as given in `submit.sh`.
- The information about the cluster the jobs are running on and the resources needed are specified in `submit.sh`, so please adjust those values if needed.
