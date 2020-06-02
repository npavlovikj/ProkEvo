#!/usr/bin/python

'''
USAGE: # ./sub-dax.py $RUN_DIR > sub-pipeline.dax
'''

import sys
import os
import glob
import fnmatch

# Import the Python DAX library
os.sys.path.insert(0, "/usr/lib64/pegasus/python")
from Pegasus.DAX3 import *

dax = ADAG("sub-pipeline")
base_dir = os.getcwd()

staging_dir = sys.argv[1]

prokka_run = []
plasmidfinder_run = []
sistr_run = []
list_of_gff_files = []
list_of_contig_files = []
list_of_filtererd_sra_ids = []
list_of_sistr_files = []


'''
# Get list of contigs after filtering
for file_name in os.listdir(run_dir):
    if file_name.endswith("_filtered.fasta"):
        filee = File(file_name)
        #filee.addPFN(PFN("file://{0}/".format(run_dir) + str(file_name), "local"))
        #dax.addFile(filee)
        list_of_contig_files.append(filee)
    else:
        pass
'''

# find all the filtered fasta files in the staging directory
filtered_fasta = []
for root, dirnames, filenames in os.walk(staging_dir):
    for filename in fnmatch.filter(filenames, '*_filtered.fasta'):
        filtered_fasta.append(os.path.join(root, filename))

for f in filtered_fasta:
    file_name = f.split('/')[-1]
    filee = File(file_name)
    filee.addPFN(PFN("stashcp://{0}".format(file_name), "stash-scp"))
    dax.addFile(filee)
    list_of_contig_files.append(filee)


i = 0
for output_filtering_contigs in list_of_contig_files:

    srr_id = output_filtering_contigs.name.split("_")[0]
		
    # add job for Prokka
    prokka_run.append(Job("ex_prokka_run"))
    prokka_run[i].addArguments(srr_id, output_filtering_contigs)
    prokka_run[i].uses(output_filtering_contigs, link=Link.INPUT)
    prokka_run[i].uses(str(srr_id) + "_prokka_output/" + str(srr_id) + ".gff", link=Link.OUTPUT, transfer=True)
    prokka_run[i].uses(str(srr_id) + "_prokka_output.tar.gz", link=Link.OUTPUT, transfer=True)
    prokka_run[i].addProfile(Profile("pegasus", "runtime", "14400"))
    prokka_run[i].addProfile(Profile("globus", "maxwalltime", "240"))
    dax.addJob(prokka_run[i])
    # add files
    f = File(str(srr_id) + "_prokka_output/" + str(srr_id) + ".gff")
    list_of_gff_files.append(f)

    # add job for plasmidfinder
    plasmidfinder_run.append(Job("ex_plasmidfinder_run"))
    plasmidfinder_run[i].addArguments(output_filtering_contigs, str(srr_id) + "_plasmidfinder_output")
    plasmidfinder_run[i].uses(output_filtering_contigs, link=Link.INPUT)
    plasmidfinder_run[i].uses(str(srr_id) + "_plasmidfinder_output.tar.gz", link=Link.OUTPUT, transfer=True)
    # plasmidfinder_run[i].addProfile(Profile("pegasus", "label", str(srr_id)))
    dax.addJob(plasmidfinder_run[i])

    # add job for sistr
    sistr_run.append(Job("ex_sistr_run"))
    sistr_run[i].addArguments(str(srr_id), output_filtering_contigs)
    sistr_run[i].uses(output_filtering_contigs, link=Link.INPUT)
    sistr_run[i].uses(str(srr_id) + "_sistr_output.csv", link=Link.OUTPUT, transfer=False)
    dax.addJob(sistr_run[i])
    list_of_sistr_files.append(str(srr_id) + "_sistr_output.csv")

    i = i + 1


# add job for mlst
mlst_run = Job("ex_mlst_run")
mlst_run.addArguments("--legacy", "--scheme", "senterica", "--csv", *list_of_contig_files)
for l in list_of_contig_files:
    mlst_run.uses(l, link=Link.INPUT)
o = File("mlst_output.csv")
mlst_run.setStdout(o)
mlst_run.uses(o, link=Link.OUTPUT, transfer=True)
mlst_run.addProfile(Profile("pegasus", "runtime", "108000"))
mlst_run.addProfile(Profile("globus", "maxwalltime", "1800"))
# mlst_run.addProfile(Profile("pegasus", "label", str(srr_id)))
dax.addJob(mlst_run)

# add job for abricate vfdb
abricate_vfdb_run = Job("ex_abricate_run")
abricate_vfdb_run.addArguments("--db", "vfdb", "--csv", *list_of_contig_files)
for l in list_of_contig_files:
    abricate_vfdb_run.uses(l, link=Link.INPUT)
o = File("sabricate_vfdb_output.csv")
abricate_vfdb_run.setStdout(o)
abricate_vfdb_run.uses(o, link=Link.OUTPUT, transfer=True)
# abricate_vfdb_run.addProfile(Profile("pegasus", "label", str(srr_id)))
dax.addJob(abricate_vfdb_run)

# add job for abricate argannot
abricate_argannot_run = Job("ex_abricate_run")
abricate_argannot_run.addArguments("--db", "argannot", "--csv", *list_of_contig_files)
for l in list_of_contig_files:
    abricate_argannot_run.uses(l, link=Link.INPUT)
o = File("sabricate_argannot_output.csv")
abricate_argannot_run.setStdout(o)
abricate_argannot_run.uses(o, link=Link.OUTPUT, transfer=True)
# abricate_argannot_run.addProfile(Profile("pegasus", "label", str(srr_id)))
dax.addJob(abricate_argannot_run)

# add job for abricate card
abricate_card_run = Job("ex_abricate_run")
abricate_card_run.addArguments("--db", "card", "--csv", *list_of_contig_files)
for l in list_of_contig_files:
    abricate_card_run.uses(l, link=Link.INPUT)
o = File("sabricate_card_output.csv")
abricate_card_run.setStdout(o)
abricate_card_run.uses(o, link=Link.OUTPUT, transfer=True)
# abricate_card_run.addProfile(Profile("pegasus", "label", str(srr_id)))
dax.addJob(abricate_card_run)

# add job for abricate ncbi
abricate_ncbi_run = Job("ex_abricate_run")
abricate_ncbi_run.addArguments("--db", "ncbi", "--csv", *list_of_contig_files)
for l in list_of_contig_files:
    abricate_ncbi_run.uses(l, link=Link.INPUT)
o = File("sabricate_ncbi_output.csv")
abricate_ncbi_run.setStdout(o)
abricate_ncbi_run.uses(o, link=Link.OUTPUT, transfer=True)
# abricate_ncbi_run.addProfile(Profile("pegasus", "label", str(srr_id)))
dax.addJob(abricate_ncbi_run)

# add job for abricate plasmidfinder
abricate_plasmidfinder_run = Job("ex_abricate_run")
abricate_plasmidfinder_run.addArguments("--db", "plasmidfinder", "--csv", *list_of_contig_files)
for l in list_of_contig_files:
    abricate_plasmidfinder_run.uses(l, link=Link.INPUT)
o = File("sabricate_plasmidfinder_output.csv")
abricate_plasmidfinder_run.setStdout(o)
abricate_plasmidfinder_run.uses(o, link=Link.OUTPUT, transfer=True)
# abricate_plasmidfinder_run.addProfile(Profile("pegasus", "label", str(srr_id)))
dax.addJob(abricate_plasmidfinder_run)

# add job for abricate resfinder
abricate_resfinder_run = Job("ex_abricate_run")
abricate_resfinder_run.addArguments("--db", "resfinder", "--csv", *list_of_contig_files)
for l in list_of_contig_files:
    abricate_resfinder_run.uses(l, link=Link.INPUT)
o = File("sabricate_resfinder_output.csv")
abricate_resfinder_run.setStdout(o)
abricate_resfinder_run.uses(o, link=Link.OUTPUT, transfer=True)
# abricate_resfinder_run.addProfile(Profile("pegasus", "label", str(srr_id)))
dax.addJob(abricate_resfinder_run)

# add job for Roary
roary_run = Job("ex_roary_run")
roary_run.addArguments("-s", "-e", "--mafft", "-p", "4", "-cd", "99.0", "-i", "95", "-f", "roary_output", *list_of_gff_files)
for l in list_of_gff_files:
    roary_run.uses(l, link=Link.INPUT)
roary_run.uses("roary_output/core_gene_alignment.aln", link=Link.OUTPUT, transfer=True)
roary_run.uses("roary_output.tar.gz", link=Link.OUTPUT, transfer=True)
roary_run.addProfile(Profile("pegasus", "runtime", "604800"))
roary_run.addProfile(Profile("globus", "maxwalltime", "10080"))
roary_run.addProfile(Profile("condor", "request_memory", "970000"))
roary_run.addProfile(Profile("condor", "memory", "970000"))
# roary_run.addProfile(Profile("pegasus", "label", str(srr_id)))
dax.addJob(roary_run)

# add job for fastbaps_run
# R script, wrapper
fastbaps_run = Job("ex_fastbaps_run")
fastbaps_output = File("fastbaps_baps.csv")
fastbaps_run.addArguments("roary_output/core_gene_alignment.aln", fastbaps_output)
fastbaps_run.uses("roary_output/core_gene_alignment.aln", link=Link.INPUT)
fastbaps_run.uses(fastbaps_output, link=Link.OUTPUT, transfer=True)
fastbaps_run.addProfile(Profile("condor", "request_memory", "30000"))
fastbaps_run.addProfile(Profile("globus", "maxmemory", "30000"))
fastbaps_run.addProfile(Profile("pegasus", "memory", "30000"))
# fastbaps_run.addProfile(Profile("pegasus", "label", str(srr_id)))
dax.addJob(fastbaps_run)

# ls
ls_run = Job("ex_ls")
# ls_run.addArguments(staging_dir)
dax.addJob(ls_run)

# add job for cat sistr files
ex_cat = Executable(namespace="dax", name="cat", version="4.0", os="linux", arch="x86_64", installed=True)
ex_cat.addPFN(PFN("/bin/cat", "condor_pool"))
dax.addExecutable(ex_cat)
output_sistr_cat = File("sistr_all.csv")
cat = Job(namespace="dax", name=ex_cat)
cat.addArguments(*list_of_sistr_files)
for l in list_of_sistr_files:
    cat.uses(l, link=Link.INPUT)
cat.setStdout(output_sistr_cat)
cat.uses(output_sistr_cat, link=Link.OUTPUT, transfer=True, register=False)
dax.addJob(cat)

# add job for sistr output filtering
output_sistr_merge_cat = File("sistr_all_merge.csv")
merge_sistr_run = Job("ex_merge_sistr_run")
merge_sistr_run.addArguments(output_sistr_cat, output_sistr_merge_cat)
merge_sistr_run.uses(output_sistr_cat, link=Link.INPUT)
merge_sistr_run.uses(output_sistr_merge_cat, link=Link.OUTPUT, transfer=True)
dax.addJob(merge_sistr_run)


length = len(list_of_contig_files)
i = 0
for i in range(0,length):
    # Add control-flow dependencies
    dax.addDependency(Dependency(parent=plasmidfinder_run[i], child=ls_run))
    dax.addDependency(Dependency(parent=prokka_run[i], child=roary_run))
    dax.addDependency(Dependency(parent=sistr_run[i], child=cat))
dax.addDependency(Dependency(parent=mlst_run, child=ls_run))
dax.addDependency(Dependency(parent=abricate_argannot_run, child=ls_run))
dax.addDependency(Dependency(parent=abricate_card_run, child=ls_run))
dax.addDependency(Dependency(parent=abricate_ncbi_run, child=ls_run))
dax.addDependency(Dependency(parent=abricate_plasmidfinder_run, child=ls_run))
dax.addDependency(Dependency(parent=abricate_resfinder_run, child=ls_run))
dax.addDependency(Dependency(parent=abricate_vfdb_run, child=ls_run))
dax.addDependency(Dependency(parent=roary_run, child=fastbaps_run))
dax.addDependency(Dependency(parent=cat, child=merge_sistr_run))


# Write the DAX to stdout
dax.writeXML(sys.stdout)
