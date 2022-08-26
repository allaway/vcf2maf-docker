# vcf2maf-vep

```
## Need to have rsync and the aws-cliv2 installed.

rsync -avr --progress rsync://ftp.ensembl.org/ensembl/pub/release-107/variation/indexed_vep_cache/homo_sapiens_vep_107_GRCh38.tar.gz $HOME/.vep/
tar -zxf $HOME/.vep/homo_sapiens_vep_107_GRCh38.tar.gz -C $HOME/.vep/

aws s3 --no-sign-request --region eu-west-1 sync s3://ngi-igenomes/igenomes/Homo_sapiens/GATK/GRCh38/ $HOME/Homo_sapiens_GATK_GRCh38/

docker run -v $HOME/vcfs:/workdir:rw -v $HOME/vep:$HOME/.vep:ro -v $HOME/Homo_sapiens_GATK_GRCh38/Sequence/WholeGenomeFasta/:$HOME/fasta -it --entrypoint /bin/bash nfosi/vcf2maf

cd /mskcc-vcf2maf-*

##technically this test file is GRCh37, but it's more just to make sure the software is all playing nice...
perl vcf2maf.pl --input-vcf tests/test.vcf --output-maf tests/test.vep.maf --ref-fasta /root/.vep/homo_sapiens/102_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --vep-path /opt/conda/envs/vcf2maf/bin/ --ncbi-build GRCh38
```
