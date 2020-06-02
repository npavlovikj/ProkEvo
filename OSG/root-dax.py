#!/usr/bin/python
import sys
import os

# Import the Python DAX library
os.sys.path.insert(0, "/usr/lib64/pegasus/python")
from Pegasus.DAX3 import *

dax = ADAG("pipeline")
base_dir = os.getcwd()

staging_dir = sys.argv[1]
submit_directory = sys.argv[2]

sra_run = []
trim_run = []
fastqc_run = []
spades_run = []
quast_run = []
filtering_run = []
prokka_run = []
plasmidfinder_run = []
forward_file = []
reverse_file = []
list_of_fastqc_files = []
list_of_gff_files = []
list_of_contig_files = []
list_of_filtererd_sra_ids = []


# Open input list and count files
input_file = open("sra_ids.txt")
lines = input_file.readlines()
input_file = open("sra_ids.txt")
length = len(input_file.readlines())


# Add file executable and job for sub-pipeline
c = File("sub-pipeline.dax")


# Add a job to analyze the output of split and generate a sub dax with correct number of parallelism based on output of previous job
generate = Job("ex_generate")
generate.addArguments(staging_dir)
generate.setStdout("sub-pipeline.dax")
generate.addProfile(Profile(namespace="env",key="PYTHONPATH",value=os.environ['PYTHONPATH']))
# The ex_generate job needs to run locally:
generate.addProfile(Profile(namespace="hints",key="execution.site",value="local"))
generate.uses(c, link=Link.OUTPUT)
dax.addJob(generate)

# Add a subdax job of type DAX that takes the runtime generated sub dax file in the previous step and runs the computation.
sub_dax = DAX(c)
sub_dax.addArguments("-Dpegasus.catalog.replica.file=%s/rc-sub.txt" % (submit_directory),
    "-Dpegasus.catalog.site.file=%s/sites.xml" % (submit_directory),"--sites condor_pool","--staging-site stash-scp","--output-site local","--basename sub-pipeline")
dax.addJob(sub_dax)


# Start analysis
for i in range(0,length):

    srr_id = lines[i].strip()

    forward_file.append(File(str(srr_id) + "_1.fastq"))
    reverse_file.append(File(str(srr_id) + "_2.fastq"))
    dax.addFile(forward_file[i])
    dax.addFile(reverse_file[i])

    # add job for downloading data
    #sra_run.append(Job("ex_sra_run"))
    #sra_run[i].addArguments(str(srr_id))
    #sra_run[i].uses(forward_file[i], link=Link.OUTPUT, transfer=False)
    #sra_run[i].uses(reverse_file[i], link=Link.OUTPUT, transfer=False)
    # add profile for download limit
    # Profile(PROPERTY_KEY[0], PROFILE KEY, PROPERTY_KEY[1])
    #sra_run[i].addProfile(Profile("dagman", "CATEGORY", "sradownload"))
    # sra_run[i].addProfile(Profile("pegasus", "label", str(srr_id)))
    #dax.addJob(sra_run[i])

    # add job for Trimmomatic
    trim_run.append(Job("ex_trim_run"))
    trim_run[i].addArguments(str(srr_id), forward_file[i].name, reverse_file[i].name)
    trim_run[i].uses(forward_file[i], link=Link.INPUT)
    trim_run[i].uses(reverse_file[i], link=Link.INPUT)
    trim_run[i].uses(str(srr_id) + "_pair_1_trimmed.fastq", link=Link.OUTPUT, transfer=False)
    #trim_run[i].uses(str(srr_id) + "_unpair_1_trimmed.fastq", link=Link.OUTPUT, transfer=False)
    trim_run[i].uses(str(srr_id) + "_pair_2_trimmed.fastq", link=Link.OUTPUT, transfer=False)
    #trim_run[i].uses(str(srr_id) + "_unpair_2_trimmed.fastq", link=Link.OUTPUT, transfer=False)
    # trim_run[i].addProfile(Profile("pegasus", "label", str(srr_id)))
    dax.addJob(trim_run[i])

    # add job for FastQC
    fastqc_run.append(Job("ex_fastqc_run"))
    fastqc_run[i].addArguments(str(srr_id))
    fastqc_run[i].uses(str(srr_id) + "_pair_1_trimmed.fastq", link=Link.INPUT)
    fastqc_run[i].uses(str(srr_id) + "_pair_2_trimmed.fastq", link=Link.INPUT)
    fastqc_run[i].uses(str(srr_id) + "_pair_1_summary.txt", link=Link.OUTPUT, transfer=False)
    fastqc_run[i].uses(str(srr_id) + "_pair_2_summary.txt", link=Link.OUTPUT, transfer=False)
    dax.addJob(fastqc_run[i])
    # add files
    f1 = File(str(srr_id) + "_pair_1_summary.txt")
    f2 = File(str(srr_id) + "_pair_2_summary.txt")
    list_of_fastqc_files.append(f1)
    list_of_fastqc_files.append(f2)

    # add job for Spades
    # Check for empty input
    spades_run.append(Job("ex_spades_run"))
    spades_run[i].addArguments(str(srr_id) + "_pair_1_trimmed.fastq", str(srr_id) + "_pair_2_trimmed.fastq", str(srr_id))
    spades_run[i].uses(str(srr_id) + "_pair_1_trimmed.fastq", link=Link.INPUT)
    spades_run[i].uses(str(srr_id) + "_pair_2_trimmed.fastq", link=Link.INPUT)
    spades_run[i].uses(str(srr_id) + "_contigs.fasta", link=Link.OUTPUT, transfer=False)
    spades_run[i].addProfile(Profile("pegasus", "runtime", "14400"))
    spades_run[i].addProfile(Profile("globus", "maxwalltime", "240"))
    spades_run[i].addProfile(Profile("condor", "request_cpus", "4"))
    # runtime and maxwalltime does not set the max running time actually. periodic_hold is needed for that:
    # spades_run[i].addProfile(Profile("condor", "periodic_hold", "JobStatus == 2 && (CurrentTime - JobCurrentStartDate) > 4*60*60"))
    # spades_run[i].addProfile(Profile("pegasus", "label", str(srr_id)))
    dax.addJob(spades_run[i])

    # add job for Quast
    quast_run.append(Job("ex_quast_run"))
    quast_run[i].addArguments(str(srr_id))
    quast_run[i].uses(str(srr_id) + "_contigs.fasta", link=Link.INPUT)
    quast_run[i].uses(str(srr_id) + "_transposed_report.tsv", link=Link.OUTPUT)
    quast_run[i].addProfile(Profile("pegasus", "runtime", "7200"))
    quast_run[i].addProfile(Profile("globus", "maxwalltime", "120"))
    # quast_run[i].addProfile(Profile("pegasus", "label", str(srr_id)))
    dax.addJob(quast_run[i])

    # add job for Filterig contigs
    # return the proper contigs file
    ff = File(str(srr_id) + "_filtered.fasta")
    dax.addFile(ff)
    filtering_run.append(Job("ex_filtering_run"))
    filtering_run[i].addArguments(str(srr_id) + "_transposed_report.tsv",str(srr_id) + "_contigs.fasta", ff)
    filtering_run[i].uses(str(srr_id) + "_transposed_report.tsv", link=Link.INPUT)
    filtering_run[i].uses(str(srr_id) + "_contigs.fasta", link=Link.INPUT)
    filtering_run[i].uses(ff, link=Link.OUTPUT, register=False, transfer=True)
    filtering_run[i].addProfile(Profile("pegasus", "runtime", "7200"))
    filtering_run[i].addProfile(Profile("globus", "maxwalltime", "120"))
    # filtering_run[i].addProfile(Profile("pegasus", "label", str(srr_id)))
    dax.addJob(filtering_run[i])

# add job for cat FastQC Fail
ex_cat = Executable(namespace="dax", name="cat", version="4.0", os="linux", arch="x86_64", installed=True)
ex_cat.addPFN(PFN("/bin/cat", "condor_pool"))
dax.addExecutable(ex_cat)
output_fastqc_cat = File("fastqc_summary_all.txt")
cat = Job(namespace="dax", name=ex_cat)
cat.addArguments(*list_of_fastqc_files)
for l in list_of_fastqc_files:
    cat.uses(l, link=Link.INPUT)
cat.setStdout(output_fastqc_cat)
cat.uses(output_fastqc_cat, link=Link.OUTPUT, transfer=True)
dax.addJob(cat)

# add job for FastQC Fail
output_fastqc_fail = File("fastqc_summary_final.txt")
fastqc_fail_run = Job("ex_fastqc_fail_run")
fastqc_fail_run.addArguments(output_fastqc_cat, output_fastqc_fail)
fastqc_fail_run.uses(output_fastqc_cat, link=Link.INPUT)
fastqc_fail_run.uses(output_fastqc_fail, link=Link.OUTPUT, transfer=True)
dax.addJob(fastqc_fail_run)


input_file = open("sra_ids.txt")
length = len(input_file.readlines())
for i in range(0,length):
    # Add control-flow dependencies
    # dax.addDependency(Dependency(parent=sra_run[i], child=trim_run[i]))
    dax.addDependency(Dependency(parent=trim_run[i], child=fastqc_run[i]))
    dax.addDependency(Dependency(parent=fastqc_run[i], child=cat))
    dax.addDependency(Dependency(parent=trim_run[i], child=spades_run[i]))
    dax.addDependency(Dependency(parent=spades_run[i], child=quast_run[i]))
    dax.addDependency(Dependency(parent=quast_run[i], child=filtering_run[i]))
    dax.addDependency(Dependency(parent=filtering_run[i], child=generate))
dax.addDependency(Dependency(parent=cat, child=fastqc_fail_run))
dax.addDependency(Dependency(parent=generate, child=sub_dax))


# Write the DAX to stdout
dax.writeXML(sys.stdout)
