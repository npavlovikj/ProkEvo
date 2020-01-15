#!/bin/bash

set -e

export PYTHONPATH=`pegasus-config --python`

TOPDIR=`pwd`

export RUN_DIR=$TOPDIR/data_tmp
mkdir -p $RUN_DIR
./root-dax.py $RUN_DIR > root-pipeline.dax

# create the site catalog
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

        <profile namespace="pegasus" key="style">glite</profile>
        <!-- tell pegasus that local-hcc is accessible on submit host -->
        <profile namespace="pegasus" key="auxillary.local">true</profile>

        <profile namespace="condor" key="grid_resource">batch slurm</profile>
        <profile namespace="pegasus" key="queue">batch</profile>
        <profile namespace="env" key="PEGASUS_HOME">/usr</profile>
        <profile namespace="condor" key="request_memory"> ifthenelse(isundefined(DAGNodeRetry) || DAGNodeRetry == 0, 2000, 60000) </profile>
    </site>

</sitecatalog>
EOF


# plan and submit the root workflow
pegasus-plan --conf pegasusrc --sites local,local-hcc --output-site local-hcc --dir ${PWD} --dax root-pipeline.dax --submit # --cluster label

# to resume/restart fixed workflow
# pegasus-run <run_directory>
