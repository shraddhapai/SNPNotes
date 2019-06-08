#' see if any lead snps are in CMC eQTLs
rm(list=ls())

snpFile <- "/home/shraddhapai/BaderLab/2015_PNC/output/gcta/nocovar_mlma_190226/FUMA/FromPhilipp_190322/all_lead_snps_files.csv"
qtF <- "/home/shraddhapai/genome_annotation/CMC_eQTL_SVA/CMC_MSSM-Penn-Pitt_DLPFC_Analysis_eQTL-adjustedSVA-binned.txt.gz"

snp <- read.delim(snpFile,sep="\t",h=T,as.is=T)
qtl <- read.table(qtF,sep=" ",h=T,as.is=T,row.names=NULL)
common <- intersect(qtl[,1],snp$rsID)
cat(sprintf("%i SNPs in common with CMC\n", length(common)))

qtl <- qtl[which(qtl[,1] %in% common),]
colnames(qtl)[1:4] <- c("rsID","CMC.ENGSID","CMC.HGNC",".")
colnames(qtl)[5:ncol(qtl)] <- paste("CMC.",colnames(qtl)[5:ncol(qtl)],sep="")
qtl2 <- qtl[,c("rsID","CMC.ENGSID","CMC.HGNC","CMC.FDR",
	"CMC.Expression_Increasing_Allele","CMC.Expression_Decreasing_Allele",
	"CMC.eQTL_type")]

dt <- format(Sys.Date(),"%y%m%d")

withcmc <- merge(x=snp,y=qtl2,by=c("rsID"), all.x=TRUE)
outFile <- sprintf("%s.withCMCeqtl.txt",snpFile)
write.table(withcmc,file=outFile,sep="\t",col=T,row=F,quote=F)

