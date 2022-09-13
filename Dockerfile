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
ENV PATH=/root/miniconda3/envs/vep/bin:$PATH

# rsync
RUN yum install -y rsync \
    tar \
    perl \
    which

# Install vcf2maf
RUN curl -s -L -o vcf2maf.tar.gz https://github.com/Sage-Bionetworks-Workflows/vcf2maf/archive/refs/heads/gnomad-genomes.tar.gz \
  && tar -zxf vcf2maf.tar.gz \
  && rm vcf2maf.tar.gz \
  && mv $(find . -maxdepth 1 -type d -name '*vcf2maf*') vcf2maf \
  && chmod a+x vcf2maf/*.pl \
  && ln -sr vcf2maf/*.pl /usr/local/bin/

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name vep > vep.yml
RUN conda init bash

RUN mkdir /workdir
