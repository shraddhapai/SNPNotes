#!/bin/bash

#### ---------------------------------------
#### Filter PGC GWAS hits to keep only those with p < 1e-9
###echo "MDD"
######inf=/home/shraddhapai/BaderLab/2015_PNC/anno/snp_anno/PGC_MDD_2018_exc23andme.gz
###oF=${inf}.plt1e9.txt
######zcat $inf | awk '(NR>1){ if ($11 < 0.000000001) {print $2"\t"$1"\t"$3"\t"$11}}' > $oF
###
###echo "BIP"
###inf=/home/shraddhapai/BaderLab/2015_PNC/anno/snp_anno/daner_PGC_BIP32b_mds7a_0416a.gz
###oF=${inf}.plt1e9.txt
###zcat $inf | awk '(NR>1){ if ($11 < 0.000000001) {print $2"\t"$1"\t"$3"\t"$11}}' > $oF

# Filter CMC q < 0.05
inf=/home/shraddhapai/BaderLab/2015_PNC/anno/snp_anno/CMC_MSSM-Penn-Pitt_DLPFC_mRNA_IlluminaHiSeq2500_gene-adjustedSVA-differentialExpression-includeAncestry-DxSCZ-DE.tsv
oF=${inf}.q0.05.txt
cat $inf | awk '(NR>1){if ($9<0.05){print}}' > $oF

# ClinicalVariants
###cat clinicalVariants.tsv | awk '{if ($1~/rs/){print}}' > clinicalVariants_rs.tsv
