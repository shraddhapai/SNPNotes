#!/bin/bash

odir=/home/shraddhapai/BaderLab/2015_PNC/anno/map_snp2gene
bedtools=/home/shraddhapai/software/bedtools2/bin/bedtools
bedSort=/home/shraddhapai/software/kent_utilities/bedSort
snpFile=/home/shraddhapai/BaderLab/2015_PNC/input/impute/merge_info0.6/all_chroms/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim

cd $odir

# loo over brain tissues, grep for enhancer states
# compile. call this A.
declare -a samps=("E067" "E071" "E072" "E073")
epidir=/home/shraddhapai/genome_annotation/Roadmap_Epigenomics
enh=brain_promoters.bed
cat /dev/null > $enh;
echo "* Compile brain promoters"
for k in ${samps[@]};do
	echo -e "\t$k"
	inf=${epidir}/${k}_15_coreMarks_mnemonics.bed.gz
	zcat $inf | grep Tss | grep -v TssBiv >> $enh
done
$bedSort $enh tmp.bed
mv tmp.bed brain_promoters.bed

