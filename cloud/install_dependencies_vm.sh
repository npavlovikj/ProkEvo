#!/bin/bash

# Install ProkEvo on EL7 Virtual Machine

# Install HTCondor, https://research.cs.wisc.edu/htcondor/instructions/el/7/stable/
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y https://research.cs.wisc.edu/htcondor/repo/8.8/el7/release/htcondor-release-8.8-1.el7.noarch.rpm
yum install -y minicondor
systemctl start condor
systemctl enable condor
# Check status
condor_status
systemctl status condor

# Install Pegasus WMS, https://pegasus.isi.edu/downloads/
yum localinstall http://download.pegasus.isi.edu/pegasus/4.9.3/rhel/7/x86_64/pegasus-4.9.3-1.el7.x86_64.rpm 
# Check version
pegasus-version

# Install Miniconda, https://docs.conda.io/projects/conda/en/latest/user-guide/install/rpm-debian.html
rpm --import https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc
cat <<EOF > /etc/yum.repos.d/conda.repo
[conda]
name=Conda
baseurl=https://repo.anaconda.com/pkgs/misc/rpmrepo/conda
enabled=1
gpgcheck=1
gpgkey=https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc
EOF
yum install conda
source /opt/conda/etc/profile.d/conda.sh
# Check version
conda -V
