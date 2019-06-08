#!/bin/bash
bedtools=/home/shraddhapai/software/bedtools2/bin/bedtools
bedSort=/home/shraddhapai/software/kent_utilities/bedSort
odir=/home/shraddhapai/BaderLab/2015_PNC/anno/map_snp2gene

cd $odir

# map snp to gene with within 10kb of gene body
genes=/home/shraddhapai/BaderLab/2015_PNC/anno/gencode.v27lift37.annotation.gtf.geneidsymbols.txt
cat $genes | awk '(NR>1){ a=$2-10000; if (a<0) {a=1}; b=$3+10000; print $1"\t"a"\t"b"\t"$5}' > gene_flank.txt

snpFile=/home/shraddhapai/BaderLab/2015_PNC/input/impute/merge_info0.6/all_chroms/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim
echo "* make SNP bed"
cat $snpFile | awk '{print "chr"$1"\t"$4"\t"$4"\t"$2}' > snp.bed
$bedSort snp.bed tmp.bed
mv tmp.bed snp.bed

$bedtools intersect -wa -wb -a snp.bed -b gene_flank.txt > snp2gene.POS.bed
