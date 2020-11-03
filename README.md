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
ProkEvo is under ongoing development and testing. If you have any questions or issues with ProkEvo and the provided instructions, please let us know. Thank you for checking out ProkEvo!


## Running ProkEvo
ProkEvo takes advantage of the [Pegasus Workflow Management System (WMS)](https://pegasus.isi.edu) to ensure reproducibility, scalability, modularity, fault-tolerance, and robust file management throughout the process. Pegasus WMS uses [HTCondor](http://research.cs.wisc.edu/htcondor) to submit workflows to various computational platforms, such as University or publicly available clusters, clouds, or distributed grids.

In order to use ProkEvo, the computational platform needs to have HTCondor and Pegasus WMS. While these can be found on the majority computational platforms, instructions for installation can be found [here]([https://research.cs.wisc.edu/htcondor/instructions/el/7/stable/](https://research.cs.wisc.edu/htcondor/instructions/el/7/stable/)) and [here]([https://pegasus.isi.edu/downloads/](https://pegasus.isi.edu/downloads/)).

There are few files in ProkEvo that need the absolute path to the working directory:
- Please replace `ProkEvo_dir` with the absolute path to the current directory in the file `rc.txt`
- Please replace `ProkEvo_dir` with the absolute path to the current directory in the file `tc.txt`
- To change the path where the conda environment is created, please specify that in `./scripts/create_conda_env.sh`
- Add the SRA ids you need in file named `sra_ids.txt`, one SRA id per line.
- To submit the pipeline, please run **./submit.sh** after these changes.

Due to differences in the computational platforms, ProkEvo has a different version for OSG. The code for this version can be found in the sub-directory `OSG`. The same modifications as the ones mentioned above hold for this version as well.


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
