# vcf2maf-vep


This Dockerfile is loosely based on [this gist](https://gist.github.com/ckandoth/61c65ba96b011f286220fa4832ad2bc0) and can be used to create a Docker image with all of the necessary dependencies for vcf2maf to run with Ensemble v112. You just need to provide (1) the VEP 112 cache (instructions for grabbing it with rsync below) and (2) the genomic FASTA that you aligned to (for the NF-OSI pipeline, we currently use the GATK GRCh38 build, which can be acquired from iGenomes (instructions for grabbing it with the AWS CLI below). 

The Docker repository for this is: https://hub.docker.com/r/nfosi/vcf2maf

Currently, this image uses a custom fork of vcf2maf to address a small incompatibility with VEP v112. When https://github.com/mskcc/vcf2maf/issues/322 is resolved, we can switch back to the real release of vcf2maf. 

```
## Need to have rsync and the aws-cliv2 installed.

## Get VEP 112 database. 
rsync -avr --progress rsync://ftp.ensembl.org/ensembl/pub/release-112/variation/indexed_vep_cache/homo_sapiens_vep_112_GRCh38.tar.gz $HOME/.vep/
tar -zxf $HOME/.vep/homo_sapiens_vep_112_GRCh38.tar.gz -C $HOME/.vep/

## Get GATK GRCh38 genome (or whatever genome you aligned to if not this one...)
aws s3 --no-sign-request --region eu-west-1 sync s3://ngi-igenomes/igenomes/Homo_sapiens/GATK/GRCh38/ $HOME/Homo_sapiens_GATK_GRCh38/

## Get vcfs. Place in $HOME/vcfs

gunzip $HOME/vcfs/*

docker run -v $HOME/vcfs:/workdir/vcfs:rw -v $HOME/.vep:/workdir/vep:ro -v $HOME/Homo_sapiens_GATK_GRCh38/Sequence/WholeGenomeFasta:/workdir/fasta:ro -v $HOME/mafs:/workdir/mafs:rw -it --entrypoint /bin/bash nfosi/vcf2maf

cd /nf-osi-vcf2maf-*

##test

perl vcf2maf.pl --input-vcf /workdir/vcfs/28cNF.Strelka.filtered.vcf --output-maf /workdir/test.vep.maf --ref-fasta /workdir/fasta/Homo_sapiens_assembly38.fasta --vep-path /root/miniconda3/envs/vcf2maf/bin --vep-data /workdir/vep --ncbi-build GRCh38

```

Example loop to run in docker container:
```

for i in /workdir/vcfs/*.vcf; do
	echo $i 
	ic=$(basename ${i})
    ic=${ic%.Strelka.filtered.vcf}  ##change this to trim to your sample ID as necessary

    echo $ic

    perl vcf2maf.pl --input-vcf $i --output-maf /workdir/${ic}.vep.maf --ref-fasta /workdir/fasta/Homo_sapiens_assembly38.fasta --vep-path /root/miniconda3/envs/vcf2maf/bin --vep-data /workdir/vep --ncbi-build GRCh38 --tumor-id $ic
done


```

## Adding support for `--af_gnomadg`

### Original command

```console
docker run \
	-v $HOME/data:/work/:rw -v /dev/shm/:/ref/:ro \
	nfosi/vcf2maf:latest \
	perl nf-osi-vcf2maf-1b34293/vcf2maf.pl --input-vcf /work/test-small.vcf \
	--output-maf /work/test-small.maf --vep-data /ref/vep \
	--ref-fasta /ref/fasta/Homo_sapiens_assembly38.fasta \
	--vep-path /root/miniconda3/envs/vcf2maf/bin --ncbi-build GRCh38
```

### Using vcf2maf.sh

This shell script adds support for `--af_gnomadg`

```console
docker run \
	-v $HOME/data:/work/:rw -v /dev/shm/:/ref/:ro \
	-v $HOME/vcf2maf-wf/:/src/:ro \
	nfosi/vcf2maf:latest \
	bash /src/vcf2maf.sh --input-vcf /work/test-small.vcf \
	--output-maf /work/test-small.maf --vep-data /ref/vep \
	--ref-fasta /ref/fasta/Homo_sapiens_assembly38.fasta \
	--vep-path /root/miniconda3/envs/vcf2maf/bin --ncbi-build GRCh38
```

### Using vcf2maf-gnomad-genomes

This uses a forked version of vcf2maf

```console
docker run \
	-v $HOME/data:/work/:rw -v /dev/shm/:/ref/:ro \
	sagebionetworks/vcf2maf:gnomad-genomes \
	vcf2maf.pl --input-vcf /work/test-small.vcf \
	--output-maf /work/test-small.maf --vep-data /ref/vep \
	--ref-fasta /ref/fasta/Homo_sapiens_assembly38.fasta \
	--vep-path /root/miniconda3/envs/vep/bin --ncbi-build GRCh38
```

