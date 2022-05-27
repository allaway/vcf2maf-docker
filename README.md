# vcf2maf-vep

```
docker run -it --entrypoint /bin/bash <image>
cd /mskcc-vcf2maf-

##technically this test file is GRCh37, but it's more just to make sure the software is all playing nice...
perl vcf2maf.pl --input-vcf tests/test.vcf --output-maf tests/test.vep.maf --ref-fasta /root/.vep/homo_sapiens/102_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --vep-path /opt/conda/envs/vcf2maf/bin/ --ncbi-build GRCh38
```
