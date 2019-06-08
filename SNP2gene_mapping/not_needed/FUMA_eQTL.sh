#!/bin/bash

gtexdir=/home/shraddhapai/genome_annotation/GTEx/GTEx_Analysis_v7_eQTL
declare -a tisList=("Brain_Anterior_cingulate_cortex_BA24.v7.egenes.txt.gz" "Brain_Cortex.v7.egenes.txt.gz" "Brain_Frontal_Cortex_BA9.v7.egenes.txt.gz" "Brain_Hippocampus.v7.egenes.txt.gz") 
odir=/home/shraddhapai/BaderLab/2015_PNC/anno/map_snp2gene
bedSort=/home/shraddhapai/software/kent_utilities/bedSort
bedtools=/home/shraddhapai/software/bedtools2/bin/bedtools

cd $odir

# collect eQTLs with q < 0.05 from brain samples
of=gtex.sigeqtls.txt
cat /dev/null > $of
for tis in ${tisList[@]}; do
    inf=${gtexdir}/${tis}
	basef=`basename $tis .v7.egenes.txt.gz`
	echo $basef
	zcat $inf | awk -v tis=$basef '{if ($29 <= 0.05) { print "chr"$14"\t"$15"\t"$15"\t"$19"\t"$2"\t"$29"\t"tis}}' >> $of
done

# filter snps based on which exist in open chromatin in the brain
# compile open chromatin coordinates
# intersect with snps
esamp=("E053" "E054" "E067" "E068" "E069" "E070" "E071" "E072" "E073" "E074" "E081" "E082" "E125")
epidir=/home/shraddhapai/genome_annotation/Roadmap_Epigenomics
of=brain.op.chrom.bed
echo "* collect open chromatin states"
cat /dev/null > $of
for samp in ${esamp[@]};do
	inf=${epidir}/${samp}_15_coreMarks_mnemonics.bed.gz
	echo $samp
	zcat $inf | awk '{ if (($4 ~ /^1_/) || ($4 ~ /^2_/) || ($4 ~ /^3_/) || ($4 ~ /^4_/) || ($4 ~ /^5_/) || ($4 ~ /^6_/) || ($4 ~ /^7_/)) {print}}' >> $of
done
$bedSort $of tmp.bed
mv tmp.bed $of

snpFile=/home/shraddhapai/BaderLab/2015_PNC/input/impute/merge_info0.6/all_chroms/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim
echo "* make SNP bed"
cat $snpFile | awk '{print "chr"$1"\t"$4"\t"$4"\t"$2}' > snp.bed
$bedSort snp.bed tmp.bed
mv tmp.bed snp.bed
echo "* intersect snp with open chromatin"
$bedtools intersect -wa -a snp.bed -b brain.op.chrom.bed > snp.op.chrom.bed

# finally map open-chromatin snps to genes with sig eqtls
$bedtools intersect -wa -wb -a snp.op.chrom.bed -b gtex.sigeqtls.txt | cut -f1-4,9-11 | uniq > snp.EQTLs.bed

