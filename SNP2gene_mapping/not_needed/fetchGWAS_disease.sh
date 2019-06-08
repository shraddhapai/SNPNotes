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

disID="EFO_0000589"


# takes a few hours per category
# after this is done, call gwas_catalog_cleanup.R after changing the input file to the output of the file below
python get_gwas.py $disID > GWAShits_${disID}.txt


