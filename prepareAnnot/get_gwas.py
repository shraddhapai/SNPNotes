#!/usr/bin/python

from opentargets import OpenTargetsClient
import sys
client = OpenTargetsClient()

disease_ID = sys.argv[1]

print disease_ID

with open('Biomart_ENGSIDs_190405.txt',mode='rU') as fp:
    for line_term in fp:
        line=line_term.rstrip('\n')
        response = client.filter_evidence()
        response.filter(target=line,disease=disease_ID)
        for i, r in enumerate(response):
            src=r['sourceID']
            if src == 'gwas_catalog':
                print(r['target']['gene_info']['symbol'],r['target']['gene_info']['name'],r['disease']['efo_info']['label'],r['unique_association_fields'])
