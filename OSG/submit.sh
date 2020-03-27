#!/bin/bash

set -e

export WORK_DIR=$HOME/pegasus-run
mkdir -p $WORK_DIR
export RUN_ID=`date +'%s'`
export STAGING_DIR=/public/${USER}/staging/${RUN_ID}

# in case the data is already downloaded and available:
# build a replica catalog, using the data we already transferred
# echo "Finding existing data ..."
# rm -f rc-generated.txt
# cp rc-base.txt rc-generated.txt
# for ENTRY in `find /stash/user/npavlovikj/public/typhimurium_new/ -name \*.fastq`; do
#     LFN=`basename $ENTRY`
#     PFN=`echo "$ENTRY" | sed 's;^/stash;stash://;'`
#     echo "$LFN  $PFN  site=\"stash\"" >>rc-generated.txt
# done

# generate the dax
PYTHONPATH=`pegasus-config --python` ./root-dax.py $STAGING_DIR $PWD > root-pipeline.dax


# create the site catalog
cat > sites.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<sitecatalog xmlns="http://pegasus.isi.edu/schema/sitecatalog" 
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
             xsi:schemaLocation="http://pegasus.isi.edu/schema/sitecatalog http://pegasus.isi.edu/schema/sc-4.0.xsd"
             version="4.0">

    <site  handle="local" arch="x86_64">
        <directory type="shared-scratch" path="/public/${USER}/scratch">
            <file-server operation="all" url="file:///public/${USER}/scratch"/>
        </directory>
        <!-- this is our output site, where final outputs will be stored -->
        <directory type="local-storage" path="/public/${USER}/final_results">
            <file-server operation="all" url="file:///public/${USER}/final_results"/>
        </directory>
        <profile namespace="pegasus" key="SSH_PRIVATE_KEY" >/home/${USER}/.ssh/workflow</profile>
        <profile namespace="condor" key="+WantsStashCache" >True</profile>
        <profile namespace="env" key="JAVA_HEAPMIN">128</profile>
        <profile namespace="env" key="JAVA_HEAPMAX">512</profile>
    </site>

    <!-- this is our staging site, where intermediate data will be stored -->
    <!-- output is in /stash/user/${USER}/staging/1570321611/00/00/ -->   
    <site  handle="stash-scp" arch="x86_64" os="LINUX">
        <directory type="shared-scratch" path="/public/${USER}/staging">
            <file-server operation="get" url="https://stash.osgconnect.net/public/${USER}/staging"/>
            <file-server operation="put" url="scp://${USER}@${HOSTNAME}/public/${USER}/staging"/>
        </directory>
    </site>

    <!-- this is our execution site on OSG -->
    <site handle="condor_pool" arch="x86_64" os="LINUX">
        <profile namespace="condor" key="requirements" >HAS_SINGULARITY == True &amp;&amp; GLIDEIN_Site =!= "OSG_US_ASU_DELL_M420" &amp;&amp; GLIDEIN_Site =!= "SU-ITS" &amp;&amp; GLIDEIN_Site =!= "Colorado" &amp;&amp; TARGET.GLIDEIN_ResourceName =!= MY.MachineAttrGLIDEIN_ResourceName1 &amp;&amp; TARGET.GLIDEIN_ResourceName =!= MY.MachineAttrGLIDEIN_ResourceName2 &amp;&amp; TARGET.GLIDEIN_ResourceName =!= MY.MachineAttrGLIDEIN_ResourceName3 &amp;&amp; TARGET.GLIDEIN_ResourceName =!= MY.MachineAttrGLIDEIN_ResourceName4</profile>
        <profile namespace="condor" key="+ProjectName" >"BioAlgorithms"</profile>
        <profile namespace="condor" key="+SingularityImage" >"/cvmfs/singularity.opensciencegrid.org/npavlovikj/bacteria_db:latest"</profile>

        <!-- tell pegasus that condor_pool is accessible on submit host -->
        <profile namespace="pegasus" key="auxillary.local">true</profile>

        <profile namespace="pegasus" key="style">condor</profile>
        <profile namespace="condor" key="universe">vanilla</profile>
        <profile namespace="condor" key="request_cpus">1</profile>
        <profile namespace="condor" key="request_memory"> ifthenelse(isundefined(DAGNodeRetry) || DAGNodeRetry &lt;= 1, 2000, 60000) </profile>
        <profile namespace="condor" key="+WantsStashCache">True</profile>
        <profile namespace="env" key="PERL5LIB">/opt/anaconda/perl5</profile>
        <profile namespace="condor" key="request_disk">9 GB</profile>
    </site>

</sitecatalog>
EOF


# plan and submit the workflow
export JAVA_HEAPMIN="128"
export JAVA_HEAPMAX="3000"
pegasus-plan -Xms128m -Xmx3000m \
    --conf pegasus.conf \
    --dir $WORK_DIR \
    --relative-dir $RUN_ID \
    --sites condor_pool \
    --staging-site stash-scp \
    --output-site local \
    --cleanup leaf \
    --dax root-pipeline.dax \
    --submit

# to resume/restart fixed workflow
# pegasus-run /work/deogun/npavlovikj/FFH/pegasus-salmonella-test-array/npavlovikj/pegasus/pipeline/20190623T231524-0500
