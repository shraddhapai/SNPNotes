#!/bin/bash
final_table=/root/annot/final_join/final_table.tsv
cat $final_table  | awk '{ if ($8 < 0.00000005){print}}' > significant_genes.tsv 
cat $final_table  | awk '{ if ($8 < 0.00000005){print}}' | awk '{print $4"_"$7}' | sort |uniq > significant_genes_simplified.tsv 
