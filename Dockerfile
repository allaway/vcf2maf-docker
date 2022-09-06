FROM amazonlinux:latest

LABEL \
  author="Robert Allaway" \
  description="vcf2maf image based on gist by ckandoth" \
  maintainer="robert.allaway@sagebionetworks.org"

#Install miniconda
RUN curl -sL https://repo.anaconda.com/miniconda/Miniconda3-py37_4.9.2-Linux-x86_64.sh -o /tmp/miniconda.sh
RUN sh /tmp/miniconda.sh -bfp /root/miniconda3
ENV PATH=/root/miniconda3/bin:$PATH


# Create conda environment 
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH=/root/miniconda3/envs/vcf2maf/bin:$PATH

# rsync
RUN yum install -y rsync \
    tar \
    perl \
    which

# Install vcf2maf
RUN bash -c 'export VCF2MAF_URL=`curl -sL https://api.github.com/repos/nf-osi/vcf2maf/releases | grep -m1 tarball_url | cut -d\" -f4`; curl -L -o nf-osi-vcf2maf.tar.gz $VCF2MAF_URL; tar -zxf nf-osi-vcf2maf.tar.gz; cd nf-osi-vcf2maf-*'

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name vcf2maf > vcf2maf.yml
RUN conda init bash

RUN mkdir /workdir

