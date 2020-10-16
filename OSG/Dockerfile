FROM centos:7

RUN yum -y upgrade && yum install -y -q libgfortran4 libgomp bzip2 libXt which epel-release yum-plugin-priorities wget less openssh-server openssh-clients && \
    # OSG repo
    yum -y install http://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm && \
    yum clean all && \
    # Pegasus repo
    echo -e "# Pegasus\n[Pegasus]\nname=Pegasus\nbaseurl=http://download.pegasus.isi.edu/wms/download/rhel/7/\$basearch/\ngpgcheck=0\nenabled=1\npriority=50" >/etc/yum.repos.d/pegasus.repo && \
    # Install required software using conda
    curl -O -L https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh && \
    sh Miniconda3-4.6.14-Linux-x86_64.sh -b -p /opt/anaconda && \
    rm Miniconda3-4.6.14-Linux-x86_64.sh && export PATH=/opt/anaconda/bin:$PATH && \
    conda config --add channels defaults && conda config --add channels bioconda && \
    conda config --add channels conda-forge && conda config --add channels hcc && \
    conda install -q -y fastqc=0.11.8 parallel-fastq-dump=0.6.5 prokka=1.14.0 tbl2asn-forever quast=5.0.2 roary=3.12.0 \
        spades=3.13.1 trimmomatic=0.39 abricate=0.8.13 r-fastbaps=1.0.1 snp-sites=2.4.1 \
        sistr_cmd=1.0.2 python=3.6 plasmidfinder=2.0.1 biopython=1.74 mlst=2.16.4 && \
    # Download Plasmidfinder db
    cd /opt/anaconda/share/plasmidfinder-2.0.1-0/database/ && \
    wget https://bitbucket.org/genomicepidemiology/plasmidfinder_db/get/9cdf35065947.tar.gz && \
    tar -xvf 9cdf35065947.tar.gz --strip-components 1 && rm *.tar.gz && python INSTALL.py

ENV PATH=/opt/anaconda/bin:$PATH
ENV PLASMID_DB=/opt/anaconda/share/plasmidfinder-2.0.1-0/database/
