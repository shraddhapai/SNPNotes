#!/bin/bash

# gets input ready for all annotation scripts
snpFile=/home/shraddhapai/BaderLab/2015_PNC/input/impute/merge_info0.6/all_chroms/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim

outbase=`basename $snpFile`
outDir=/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/

cmcf=${outDir}/${outbase}.
cat $snpFile | cut -f2 > ${cmcf}.cmc.txt
