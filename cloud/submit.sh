#!/bin/bash

set -e

export PYTHONPATH=`pegasus-config --python`

TOPDIR=`pwd`

<<DO_NOT_COMMENT_OUT
You can use raw Illumina sequences stored locally instead of downloading them from NCBI.
To do this, you will need to add information about the input files in rc.txt.
You can add these files in a loop as shown below, or any way you prefer.
You should also comment out the dependency in root-dax.py to skip the download.
DO_NOT_COMMENT_OUT

<<COMM
while read line
do
echo ''${line}'_1.fastq file:///absolute_path_to_fastq_files/'${line}'_1.fastq site="local"' >> rc.txt
echo ''${line}'_2.fastq file:///absolute_path_to_fastq_files/'${line}'_2.fastq site="local"' >> rc.txt
done < sra_ids.txt 
COMM

# Clean old directories and files
rm -rf data_tmp
rm -rf scratch 
rm -rf outputs
rm -rf $USER
rm -rf root-pipeline.dax 
rm -rf sites.xml 
rm -rf rc.txt
cp rc.txt.org rc.txt

# Set working path to current directory
sed -i "s|ProkEvo_dir|$PWD|g" tc.txt
sed -i "s|ProkEvo_dir|$PWD|g" rc.txt
for i in scripts/*.sh
do
sed -i "s|ProkEvo_dir|$PWD|g" $i
done

export RUN_DIR=$TOPDIR/data_tmp
mkdir -p $RUN_DIR
./root-dax.py $RUN_DIR > root-pipeline.dax

# create the site catalog
# this section contains the information about the running site
cat > sites.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<sitecatalog xmlns="http://pegasus.isi.edu/schema/sitecatalog" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://pegasus.isi.edu/schema/sitecatalog http://pegasus.isi.edu/schema/sc-4.0.xsd" version="4.0">

    <site  handle="local-hcc" arch="x86_64" os="LINUX">
        <directory type="shared-scratch" path="${PWD}/scratch">
            <file-server operation="all" url="file://${PWD}/scratch"/>
        </directory>
        <directory type="local-storage" path="${PWD}/outputs">
            <file-server operation="all" url="file://${PWD}/outputs"/>
        </directory>

        <profile namespace="pegasus" key="style">condor</profile>
        <profile namespace="condor" key="universe">local</profile>
        <!-- tell pegasus that local-hcc is accessible on submit host -->
        <profile namespace="pegasus" key="auxillary.local">true</profile>

        <profile namespace="env" key="PEGASUS_HOME">/usr</profile>
        <profile namespace="condor" key="request_memory"> ifthenelse(isundefined(DAGNodeRetry) || DAGNodeRetry == 0, 2000, 120000) </profile>
    </site>

</sitecatalog>
EOF


# plan and submit the root workflow
pegasus-plan --conf pegasusrc --sites local-hcc --output-site local-hcc --dir ${PWD} --dax root-pipeline.dax --submit # --cluster label

# to resume/restart fixed workflow
# pegasus-run <run_directory>
