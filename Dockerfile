FROM nfcore/sarekvep:2.7.1.GRCh38
LABEL \
  author="Robert Allaway" \
  description="vcf2maf image based on sarek vep container" \
  maintainer="robert.allaway@sagebionetworks.org"

RUN conda init bash
RUN bash -c 'conda activate nf-core-sarek-vep-2.6.1; conda install -c bioconda genesplicer=1.0 htslib=1.10.2 bcftools=1.10.2 samtools=1.10 ucsc-liftover=377'

RUN bash -c 'export VCF2MAF_URL=`curl -sL https://api.github.com/repos/mskcc/vcf2maf/releases | grep -m1 tarball_url | cut -d\" -f4`'
RUN bash -c 'curl -L -o mskcc-vcf2maf.tar.gz $VCF2MAF_URL; tar -zxf mskcc-vcf2maf.tar.gz; cd mskcc-vcf2maf-*'

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name nf-core-sarek-vep-2.6.1 > nf-core-sarek-vep-2.6.1.yml
