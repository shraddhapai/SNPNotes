#!/bin/bash

# download annovar database for snp annotation

cd /home/shraddhapai/software/annovar
#perl annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp147 humandb/
perl annotate_variation.pl -buildver hg19 -downdb -webfrom annovar ljb26_all humandb/
