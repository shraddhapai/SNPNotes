#!/bin/bash

# fetch gwas associations for disease category

## nervous system disease EFO0000618
## metabolic disease EFO_0000589 

## For EFO ID (ontology tree), go here:
## https://www.ebi.ac.uk/ols/ontologies/efo/terms?iri=http%3A%2F%2Fwww.ebi.ac.uk%2Fefo%2FEFO_0000408
### This is the tree for "disease". You want the child categories of this.
## e.g. "metabolic disease". Click on the link for the child.
## The EFO ID for that child will be right under the corresponding title on
## the page. 
###EFO_0000618 nervous system disease
###EFO_0000589 metabolic disease
###EFO_0000319 cardiovascular
###EFO_0000540 immune system disease
###EFO_0005741 infectious disease
###EFO_0000311 cancer
###EFO_0005105 lipid or lipoprotein measure

dlist=("EFO_0000319" "EFO_0000540" "EFO_0005741" "EFO_0000311" "EFO_0005105" "EFO_0000589" "EFO_0000618" )

for disID in ${dlist[@]};do
	echo $disID
	# takes a few hours per category
	# after this is done, call gwas_catalog_cleanup.R 
	# after changing the input file to the output of the file below
	python get_gwas.py $disID > GWAShits_${disID}.txt
	Rscript gwas_catalog_cleanup.R GWAShits_${disID}.txt
done
