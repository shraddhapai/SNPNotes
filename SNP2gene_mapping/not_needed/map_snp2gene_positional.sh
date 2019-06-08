#!/bin/bash

# use bedtools to map snps to genes positionally
snpFile=/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/PNC_snps.bed
geneFile=/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/gencode.v27lift37.annotation.gtf.geneidsymbols.txt.bed

# extends gene by 5000 - hardcoded
echo "extending"
cat $geneFile | awk '(NR>1){x=$2-5000; if (x<1) {x=1}; y=$3+5000; print $1"\t"x"\t"y"\t"$4}' > ${geneFile}.extended5000.bed
bedtools=/home/shraddhapai/software/bedtools2/bin/bedtools
$bedtools intersect -wa -wb -a $snpFile -b ${geneFile}.extended5000.bed > PNC_snps_genes.bed
