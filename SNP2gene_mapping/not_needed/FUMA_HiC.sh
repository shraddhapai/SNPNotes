#!/bin/bash

odir=/home/shraddhapai/BaderLab/2015_PNC/anno/map_snp2gene
bedtools=/home/shraddhapai/software/bedtools2/bin/bedtools
bedSort=/home/shraddhapai/software/kent_utilities/bedSort
snpFile=/home/shraddhapai/BaderLab/2015_PNC/input/impute/merge_info0.6/all_chroms/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim

cd $odir

# loop over brain tissues, grep for enhancer states
# compile. call this A.
declare -a samps=("E067" "E071" "E072" "E073")
epidir=/home/shraddhapai/genome_annotation/Roadmap_Epigenomics
enh=brain_enhancers.bed
cat /dev/null > $enh;
echo "* Compile brain enhancers"
for k in ${samps[@]};do
	echo -e "\t$k"
	inf=${epidir}/${k}_15_coreMarks_mnemonics.bed.gz
	zcat $inf | grep Enh | grep -v EnhBiv >> $enh
done
$bedSort $enh tmp.bed
mv tmp.bed brain_enhancers.bed

# compile hic interactions
# get TSS-250, TSS+500 for genes
# intersect the two. Call this B.
hic=/home/shraddhapai/BaderLab/2015_PNC/anno/HiC_PFC/PFC_GOTHIC40k_bon_0.05_FR_gene_annotation.txt
genes=/home/shraddhapai/BaderLab/2015_PNC/anno/gencode.v27lift37.annotation.gtf.geneidsymbols.txt
tail -n+2 $hic | cut -f1-3 > tmp.txt
tail -n+2 $hic | cut -f4-6 > tmp2.txt
echo "* Get PFC HiC"
cat tmp.txt tmp2.txt > ${odir}/pfc_hic.txt
echo "* Get gene TSS"
cat $genes | awk '(NR>1){ a=$2-250; if (a<0) {a=1}; b=$2+500; print $1"\t"a"\t"b"\t"$5}' > ${odir}/gene_peritss.txt
$bedSort ${odir}/gene_peritss.txt ${odir}/tmp.txt
$bedSort ${odir}/pfc_hic.txt ${odir}/tmp2.txt
mv tmp.txt gene_peritss.txt
mv tmp2.txt pfc_hic.txt
$bedtools intersect -wa -wb -a pfc_hic.txt -b gene_peritss.txt | cut -f 1-3,7 > hic_genes.txt

# Now take SNPs
# Filter for those that intersect with A (in enhancers)
echo "* make SNP bed"
cat $snpFile | awk '{print "chr"$1"\t"$4"\t"$4"\t"$2}' > snp.bed
$bedSort snp.bed tmp.bed
mv tmp.bed snp.bed

# map to B genes if overlapping.
echo "* intersect snp with brain enhancers"
$bedtools intersect -wa -a snp.bed -b brain_enhancers.bed > snp.enhancers.bed

# finally map enhancer SNPs to hic genes
$bedtools intersect -wa -wb -a snp.enhancers.bed -b hic_genes.txt  | cut -f4,8 | sort -k1,2 | uniq > snp2gene.HIC.bed



