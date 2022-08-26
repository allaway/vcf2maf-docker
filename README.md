# vcf2maf-vep

```
tar -xvzf homo_sapiens_vep_107_GRCh38.tar.gz


docker run -v $HOME/vcfs:/workdir:rw -v $HOME/vep:$HOME/.vep:ro -v $HOME/Homo_sapiens_GATK_GRCh38/Sequence/WholeGenomeFasta/:$HOME/fasta -it --entrypoint /bin/bash nfosi/vcf2maf

cd /mskcc-vcf2maf-*

##technically this test file is GRCh37, but it's more just to make sure the software is all playing nice...
perl vcf2maf.pl --input-vcf tests/test.vcf --output-maf tests/test.vep.maf --ref-fasta /root/.vep/homo_sapiens/102_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --vep-path /opt/conda/envs/vcf2maf/bin/ --ncbi-build GRCh38
```
