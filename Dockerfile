FROM amazonlinux:latest

LABEL \
  author="Robert Allaway" \
  description="vcf2maf image based on sarek vep container" \
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

# Get v106 cache
RUN mkdir -p $HOME/.vep/
#RUN rsync -avr --progress rsync://ftp.ensembl.org/ensembl/pub/release-107/variation/indexed_vep_cache/homo_sapiens_vep_107_GRCh38.tar.gz $HOME/.vep/
#RUN tar -zxf $HOME/.vep/homo_sapiens_vep_107_GRCh38.tar.gz -C $HOME/.vep/
#RUN rsync -avr --progress rsync://ftp.ensembl.org/pub/release-106/fasta/homo_sapiens/dna_index/Homo_sapiens.GRCh38.dna.toplevel.fa.gz

# Get GATK FASTA
#RUN aws s3 --no-sign-request --region eu-west-1 sync s3://ngi-igenomes/igenomes/Homo_sapiens/GATK/GRCh38/ $HOME/Homo_sapiens_GATK_GRCh38/

# Install vcf2maf
RUN bash -c 'export VCF2MAF_URL=`curl -sL https://api.github.com/repos/mskcc/vcf2maf/releases | grep -m1 tarball_url | cut -d\" -f4`; curl -L -o mskcc-vcf2maf.tar.gz $VCF2MAF_URL; tar -zxf mskcc-vcf2maf.tar.gz; cd mskcc-vcf2maf-*'

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name vcf2maf > vcf2maf.yml
RUN conda init bash

RUN mkdir /workdir
