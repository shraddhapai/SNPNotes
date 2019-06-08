#' map snps to genes using prefrontal cortex Hi-C data

snpFile=/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/PNC_snps.bed
gothic=/home/shraddhapai/BaderLab/2015_PNC/anno/HiC_PFC/PFC_GOTHIC40k_bon_0.05_FR_gene_annotation.txt
homer=/home/shraddhapai/BaderLab/2015_PNC/anno/HiC_PFC/PFC_HOMER_40k_FR_gene_annotation.txt
bedSort=/home/shraddhapai/software/kent_utilities/bedSort
bedtools=/home/shraddhapai/software/bedtools2/bin/bedtools
ep=/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/output/Roadmap_67.68.72.73_enhprom.bed

odir=/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/hic
cd $odir

###echo "GOTHIC"
###cat $gothic | grep -v NULL | awk '(NR>1){if ($1 == $4){print}}' | cut -f 1-3,7 > tmp.enh # rm trans
###echo " sorting"
###$bedSort tmp.enh gothic.cis.enh.bed
###echo " ol enh"
###$bedtools intersect -wa -wb -a $snpFile -b gothic.cis.enh.bed | cut -f 4,8 | awk '{gsub(/;/,","); print;}' | sort -k1,2 | uniq > PNC_snps.gothic.enh

echo "HOMER"
cat $homer | grep -v NULL | awk '(NR>1){if ($1 == $4){print}}' | cut -f 1-3,7 > tmp.enh # rm trans
echo " sorting"
$bedSort tmp.enh homer.cis.enh.bed

# now intersect with active enhancer promoters.
echo "Intersect homer with e/p"
$bedSort $ep Roadmap.sorted
$bedtools intersect -a homer.cis.enh.bed -b Roadmap.sorted > homer.Roadmap.intersect
# now intersect this confirmed set of e/p with snps
echo " ol enh"
$bedtools intersect -wa -wb -a $snpFile -b homer.Roadmap.intersect | cut -f 4,8 | awk '{gsub(/;/,","); print;}' | sort -k1,2 | uniq > PNC_snps.homer.unique.enh

