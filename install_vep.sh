#!/bin/bash

mkdir -p $HOME/.vep/homo_sapiens/102_GRCh38/
rsync -avr --progress rsync://ftp.ensembl.org/ensembl/pub/release-102/variation/indexed_vep_cache/homo_sapiens_vep_102_GRCh38.tar.gz $HOME/.vep/
tar -zxf $HOME/.vep/homo_sapiens_vep_102_GRCh38.tar.gz -C $HOME/.vep/
rsync -avr --progress rsync://ftp.ensembl.org/ensembl/pub/release-102/fasta/homo_sapiens/dna_index/ $HOME/.vep/homo_sapiens/102_GRCh38/
mkdir -p $HOME/.vep/homo_sapiens/102_GRCh37/

rsync -avr --progress rsync://ftp.ensembl.org/ensembl/pub/release-102/variation/indexed_vep_cache/homo_sapiens_vep_102_GRCh37.tar.gz $HOME/.vep/
tar -zxf $HOME/.vep/homo_sapiens_vep_102_GRCh37.tar.gz -C $HOME/.vep/
rsync -avr --progress rsync://ftp.ensembl.org/ensembl/pub/grch37/release-102/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.dna.toplevel.fa.gz $HOME/.vep/homo_sapiens/102_GRCh37/
gzip -d $HOME/.vep/homo_sapiens/102_GRCh37/Homo_sapiens.GRCh37.dna.toplevel.fa.gz
bgzip -i $HOME/.vep/homo_sapiens/102_GRCh37/Homo_sapiens.GRCh37.dna.toplevel.fa
samtools faidx $HOME/.vep/homo_sapiens/102_GRCh37/Homo_sapiens.GRCh37.dna.toplevel.fa.gz
