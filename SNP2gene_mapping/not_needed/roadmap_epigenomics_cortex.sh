#!/bin/bash

cd /home/shraddhapai/genome_annotation/Roadmap_Epigenomics
outdir=/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno
snpFile=/home/shraddhapai/BaderLab/2015_PNC/input/impute/merge_info0.6/all_chroms/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim

# downloaded from https://egg2.wustl.edu/roadmap/web_portal/chr_state_learning.html#core_15state
#wget http://egg2.wustl.edu/roadmap/data/byFileType/chromhmmSegmentations/ChmmModels/coreMarks/jointModel/final/all.mnemonics.bedFiles.tgz
# tar xvfz all.mnenomics.bedFiles.tgz

# E067 Angular gyrus
# E068 Anterior cingulate
# E072 Inferior temporal lobe 
# E073 DLPFC
outFile=${outdir}/Roadmap_67.68.72.73_enhprom.bed
zcat E073_15_coreMarks_mnemonics.bed.gz | awk '{if ($4 == "6_EnhG" || $4=="7_Enh" || $4=="1_TssA") {print}}' > $outFile
zcat E067_15_coreMarks_mnemonics.bed.gz | awk '{if ($4 == "6_EnhG" || $4=="7_Enh" || $4=="1_TssA") {print}}' >> $outFile
zcat E068_15_coreMarks_mnemonics.bed.gz | awk '{if ($4 == "6_EnhG" || $4=="7_Enh" || $4=="1_TssA") {print}}' >> $outFile
zcat E072_15_coreMarks_mnemonics.bed.gz | awk '{if ($4 == "6_EnhG" || $4=="7_Enh" || $4=="1_TssA") {print}}' >> $outFile

