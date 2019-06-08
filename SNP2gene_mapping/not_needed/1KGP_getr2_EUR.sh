#!/bin/bash

### file names need to be cleaned.
### currently runs manually, not automated, still in draft mode.

plink=/home/shraddhapai/software/plink/plink
bcftools=/home/shraddhapai/software/bcftools-1.6/bcftools

vcfFile=/home/shraddhapai/genome_annotation/1KGP/ALL.chr6.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
vcfDir=/home/shraddhapai/genome_annotation/1KGP
eurFile=/home/shraddhapai/genome_annotation/1KGP/integrated_call_samples_v3.20130502.ALL.panel.EUR

cd $vcfDir
for chr in {1..22};do
	vcfPfx=ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
	#$bcftools view -S $eurFile -o test.vcf $vcfFile

	# extract biallelic PASS only snps
	#$plink --vcf test.vcf --vcf-filter PASS --biallelic-only --out test.filtered

	#remove MAF=0
	#$plink --bfile test.filtered.vcf --list-duplicate-vars ids-only suppress-first
	#$plink --bfile test.filtered.vcf --exclude plink.dupvar --make-bed --out test.rmdup
	#$plink --bfile test.rmdup --maf 0.000001 --make-bed --out test.clean

	#$plink --bfile test.clean --r2 --ld-window 99999 --ld-window-r2 0.05 
tr -s ' ' 
	rm test.vcf
	rm test.filtered.bim test.filtered.bed test.filtered.fam test.filtered.log
	rm test.rmdup.bim test.rmdup.bed test.rmdup.fam test.rmdup.log
	rm plink.dupvar 
done
