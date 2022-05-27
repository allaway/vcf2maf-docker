FROM nfcore/base:1.9
LABEL \
  author="Robert Allaway" \
  description="vcf2maf image based on sarek vep container" \
  maintainer="robert.allaway@sagebionetworks.org"

# Create conda environment 
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/vcf2maf/bin:$PATH

# Install VEP and build indices
COPY install_vep.sh /bin/install_vep.sh
RUN bash -c "chmod 755 /bin/install_vep.sh"
RUN /bin/install_vep.sh

# Install vcf2maf
RUN bash -c 'export VCF2MAF_URL=`curl -sL https://api.github.com/repos/mskcc/vcf2maf/releases | grep -m1 tarball_url | cut -d\" -f4`; curl -L -o mskcc-vcf2maf.tar.gz $VCF2MAF_URL; tar -zxf mskcc-vcf2maf.tar.gz; cd mskcc-vcf2maf-*'

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name vcf2maf > vcf2maf.yml

RUN mkdir /workdir
