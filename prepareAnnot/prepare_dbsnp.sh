#!/bin/bash

zcat common_all_20180423.vcf.gz | grep -v"^#" | awk '{print "chr"$1"\t"$2"\t"$2"\t"$3}' > dbsnp151.full.bed

declare -a chrList=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y);
for  chr in ${chrList[@]}; do
        echo "chr${chr}"
        cat dbsnp151.full.bed | grep "^chr${chr}\s" > dbsnp151.chr${chr}.bed
	sort -k1,1 -k2,2n -k3,3n dbsnp151.chr${chr}.bed > dbsnp151.chr${chr}.sorted.bed
done

cat dbsnp151.chr*.sorted.bed > dbsnp151.chr1-22_X_Y.bed

echo "* sort dbSNP bed file"
sort -k1,1 -k2,2n -k3,3n $dbSNP > ${dbSNP}.sorted.bed
exit 0
