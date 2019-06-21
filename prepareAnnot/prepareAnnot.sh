#!/bin/bash

# ------------------------------------------------
annotDir=/root/annot  #### USER DIRECTORY WITH ANNOTATION FILES

bedSort=/home/spai/software/kent_utilities/bedSort
bedtools=/home/spai/software/bedtools2/bin/bedtools
gtexOut=${annotDir}/GTEx_Analysis_v7_eQTL

## Samples to parse from GTEx. 
setName=gut  ### tissue set name - doesn't matter
GWAShits=${annotDir}/GWAShits_EFO_0000589.txt.formatted.txt ## GWAS hits by disease category
## samples from GTEx to collect eQTLs from
declare -a GTEx_tisList=("Colon_Sigmoid.v7.signif_variant_gene_pairs.txt.gz" "Esophagus_Muscularis.v7.signif_variant_gene_pairs.txt.gz" "Colon_Transverse.v7.signif_variant_gene_pairs.txt.gz" "Small_Intestine_Terminal_Ileum.v7.signif_variant_gene_pairs.txt.gz" "Esophagus_Mucosa.v7.signif_variant_gene_pairs.txt.gz" "Stomach.v7.signif_variant_gene_pairs.txt.gz") 
## samples from Roadmap Epigenomics to collect open chromatin states from
declare -a Roadmap_sampList=("E092" "E085" "E084" "E109" "E106" "E075" "E101" "E102" "E110" "E077" "E079" "E094")

# ------------------------------------------------

###echo "----------------------------------"
###echo "Preparing dbSNP"
###echo "----------------------------------"
###./prepare_dbsnp.sh

###echo "----------------------------------"
###echo "Roadmap Epigenomics"
###echo "----------------------------------"
###opFile=${annotDir}/${setName}.op.chrom.bed
###cat /dev/null > $opFile
###for samp in ${Roadmap_sampList[@]};do
###	inf=${annotDir}/${samp}_15_coreMarks_mnemonics.bed.gz
###	echo $samp
###	zcat $inf | awk '{ if (($4 ~ /^1_/) || ($4 ~ /^2_/) || ($4 ~ /^3_/) || ($4 ~ /^4_/) || ($4 ~ /^5_/) || ($4 ~ /^6_/) || ($4 ~ /^7_/)) {print}}' >> $opFile 
###done
###$bedSort $opFile tmp.bed
###mv tmp.bed $opFile

echo "----------------------------------"
echo "GTEx"
echo "----------------------------------"

eqtlFile=${gtexOut}/${setName}.sigeqtls.tmp
cat /dev/null > $eqtlFile
for tis in ${GTEx_tisList[@]}; do
    inf=${gtexOut}/${tis}
	basef=`basename $tis .v7.signif_variant_gene_pairs.txt.gz`
	echo -e "\t$basef"
	zcat $inf | awk -v tis=$basef '(NR>1){ print $1"\t"$2"\t"tis }' >> $eqtlFile
done
echo "* Parse to txt file"
cat ${gtexOut}/${setName}.sigeqtls.tmp | awk '(NR>1){split($1,a,"_"); print "chr"a[1]"\t"a[2]"\t"a[2]"\t.\t"$2"\t"$3}' > ${gtexOut}/${setName}.sigeqtls.txt
eqtlFile=${gtexOut}/${setName}.sigeqtls.txt

###echo "----------------------------------"
###echo "ClinVar"
###echo "----------------------------------"
###zcat ${annotDir}/variant_summary.txt.gz | awk -F "\t" '{print $5"\t"$7"\t"$10"\t"$14}' | uniq  > ${annotDir}/clinvar.bed
###
###echo "----------------------------------"
###echo "GWAS hits"
###echo "----------------------------------"
###awk -F "\t" '{print $1"\t"$3"\t"$13"\t"$15}' $GWAShits |uniq > ${annotDir}/GWAShits.tmp
###
