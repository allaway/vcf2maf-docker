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
# COPY install_vep.sh /bin/install_vep.sh
# RUN bash -c "chmod 755 /bin/install_vep.sh"
# RUN /bin/install_vep.sh

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN sudo ./aws/install

# Get v106 cache
RUN mkdir -p $HOME/.vep/homo_sapiens/102_GRCh38/
RUN rsync -avr --progress rsync://ftp.ensembl.org/pub/release-106/variation/indexed_vep_cache/homo_sapiens_vep_106_GRCh38.tar.gz $HOME/.vep/
RUN tar -zxf $HOME/.vep/homo_sapiens_vep_106_GRCh38.tar.gz -C $HOME/.vep/
#RUN rsync -avr --progress rsync://ftp.ensembl.org/pub/release-106/fasta/homo_sapiens/dna_index/Homo_sapiens.GRCh38.dna.toplevel.fa.gz

# Get GATK FASTA
RUN aws s3 --no-sign-request --region eu-west-1 sync s3://ngi-igenomes/igenomes/Homo_sapiens/GATK/GRCh38/ $HOME/Homo_sapiens_GATK_GRCh38/

# Install vcf2maf
RUN bash -c 'export VCF2MAF_URL=`curl -sL https://api.github.com/repos/mskcc/vcf2maf/releases | grep -m1 tarball_url | cut -d\" -f4`; curl -L -o mskcc-vcf2maf.tar.gz $VCF2MAF_URL; tar -zxf mskcc-vcf2maf.tar.gz; cd mskcc-vcf2maf-*'

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name vcf2maf > vcf2maf.yml

RUN mkdir /workdir
