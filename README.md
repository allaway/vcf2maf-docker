# vcf2maf-vep

```
## Need to have rsync and the aws-cliv2 installed.

## Get VEP 107 database. 
rsync -avr --progress rsync://ftp.ensembl.org/ensembl/pub/release-107/variation/indexed_vep_cache/homo_sapiens_vep_107_GRCh38.tar.gz $HOME/.vep/
tar -zxf $HOME/.vep/homo_sapiens_vep_107_GRCh38.tar.gz -C $HOME/.vep/

## Get GATK GRCh38 genome (or whatever genome you aligned to if not this one...)
aws s3 --no-sign-request --region eu-west-1 sync s3://ngi-igenomes/igenomes/Homo_sapiens/GATK/GRCh38/ $HOME/Homo_sapiens_GATK_GRCh38/

## Get vcfs. Place in $HOME/vcfs

docker run -v $HOME/vcfs:/workdir/vcfs:rw -v $HOME/vep:/workdir/vep:ro -v $HOME/Homo_sapiens_GATK_GRCh38/Sequence/WholeGenomeFasta:/workdir/fasta:ro -it --entrypoint /bin/bash nfosi/vcf2maf

cd /nf-osi-vcf2maf-*

##test

perl vcf2maf.pl --input-vcf /workdir/vcfs/28cNF.Strelka.filtered.vcf --output-maf /workdir/test.vep.maf --ref-fasta /workdir/fasta/Homo_sapiens_assembly38.fasta --vep-path /root/miniconda3/envs/vcf2maf/bin --vep-data /workdir/vep --ncbi-build GRCh38

```
