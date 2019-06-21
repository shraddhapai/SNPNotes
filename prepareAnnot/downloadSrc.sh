#!/bin/bash

# download data sources for VCF annotation
annotDir=/root/annot/TEST_ANNOT
mkdir -p $annotDir

cd $annotDir

# dbSNP
wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b151_GRCh37p13/VCF/common_all_20180423.vcf.gz

# Roadmap Epigenomics
wget https://egg2.wustl.edu/roadmap/data/byFileType/chromhmmSegmentations/ChmmModels/coreMarks/jointModel/final/all.mnemonics.bedFiles.tgz
tar xvfz all.mnemonics.bedFiles.tgz

# GTEx tissues
wget https://storage.googleapis.com/gtex_analysis_v7/single_tissue_eqtl_data/GTEx_Analysis_v7_eQTL.tar.gz
tar xvfz GTEx_Analysis_v7_eQTL.tar.gz

# ClinVar
wget ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz

# NHGRI-EBI catalogue
### Downloading GWAS associations for each disease category takes hours
### This has already been precompiled on YYMMDD. 
### To recompute, uncomment the line below 
### ./fetchGWAS_byDiseaseCategory.sh
mv GWAShits/*txt ${annotDir}/.
