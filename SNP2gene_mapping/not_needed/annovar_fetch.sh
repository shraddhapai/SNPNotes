#!/bin/bash

annovar=/home/shraddhapai/software/annovar/table_annovar.pl
humandb=/home/shraddhapai/software/annovar/humandb/
infile=~/BaderLab/2015_PNC/output/snp_anno/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim.annovar.input.txt
outFile=~/BaderLab/2015_PNC/output/snp_anno/annovar

# making annovar input file from bim file
#cat PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim | awk '{print $1"\t"$4"\t"$4"\t"$5"\t"$6"^C"$2}' > ~/BaderLab/2015_PNC/output/snp_anno/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim.annovar.input.txt

#head -n 2000 $infile > test.snps
#perl $annovar test.snps $humandb -buildver hg19 -out $outFile -remove -protocol refGene,ljb26_all -operation g,f -nastring . 
perl $annovar $infile $humandb -buildver hg19 -out $outFile -remove -protocol refGene,avsnp147 -operation g,f -nastring . 


