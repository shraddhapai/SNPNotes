# SNPNotes

This pipeline annotates variants based on multiple sources of prior knowledge, including the GWAS literature, tissue-specific open chromatin, tissue-specific modulation of gene expression, and clinical pathogenicity.

Requirements
-------------
* R dplyr package
* bedtools


To download and prepare annotation files
---------------------------------------- 

$ cd prepareAnnot/

Update "annotDir" in downloadSrc.sh to the directory where your annotation files will be stored.

$ ./downloadSrc.sh




