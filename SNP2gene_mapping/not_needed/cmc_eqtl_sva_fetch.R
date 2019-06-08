#' look up SNPs of interest in the CommonMindConsortium eQTL listing

snpFile="/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim..cmc.txt" 
outFile="/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim.cmcanno.txt"
cmcFile <- "/home/shraddhapai/genome_annotation/CMC_eQTL_SVA/CMC_MSSM-Penn-Pitt_DLPFC_Analysis_eQTL-adjustedSVA-binned.txt.gz"
geneFile <- "/home/shraddhapai/genome_annotation/hg19/gencode.v27lift37.annotation.gtf.geneidsymbols.txt"

options(stringsAsFactors=TRUE)

snps <- read.delim(snpFile,sep="\t",h=T,as.is=T)[,1]

# read cmc file, map ENS ids to HGNC symbols
cmc <- read.table(cmcFile,as.is=T,h=T,sep=" ",row.names=NULL)
colnames(cmc)[1:5] <- c("SNP","Gene_symbol","","","FDR")
genes <- read.delim(geneFile,sep="\t",h=T,as.is=T)
dpos <- regexpr("\\.",genes$gene_id)
genes$gene_id2 <- substr(genes$gene_id,1,dpos-1)
cmc$HGNC <- genes$gene_symbol[match(cmc$Gene_symbol, genes$gene_id2)]

cmc <- subset(cmc, SNP %in% snps)
cmc <- cmc[order(cmc$FDR),]
cmc <- cmc[,c("SNP","HGNC")]
write.table(cmc,file=outFile,sep="\t",col=T,row=F,quote=F)






