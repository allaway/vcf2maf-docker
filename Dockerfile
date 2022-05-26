FROM nfcore/base:1.9
LABEL \
  author="Robert Allaway" \
  description="vcf2maf image based on sarek vep container" \
  maintainer="robert.allaway@sagebionetworks.org"

#SHELL ["/bin/bash", "-c"]
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a

ENV PATH /opt/conda/envs/vcf2maf/bin:$PATH

COPY install_vep.sh /install_vep.sh
RUN install_vep.sh

#RUN . /opt/conda/etc/profile.d/conda.sh && \
#    source activate nf-core-sarek-vep-2.7.1 && \
#    conda install -c bioconda htslib=1.10.2 bcftools=1.10.2 samtools=1.10 ucsc-liftover=377

RUN bash -c 'export VCF2MAF_URL=`curl -sL https://api.github.com/repos/mskcc/vcf2maf/releases | grep -m1 tarball_url | cut -d\" -f4`; curl -L -o mskcc-vcf2maf.tar.gz $VCF2MAF_URL; tar -zxf mskcc-vcf2maf.tar.gz; cd mskcc-vcf2maf-*'

# Add conda installation dir to PATH (instead of doing 'conda activate')

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name vcf2maf > vcf2maf.yml
