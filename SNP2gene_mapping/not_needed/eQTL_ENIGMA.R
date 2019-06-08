#' see if any lead snps are in CMC eQTLs
rm(list=ls())

snpFile <- "/home/shraddhapai/BaderLab/2015_PNC/output/gcta/nocovar_mlma_190226/FUMA/FromPhilipp_190322/all_lead_snps_files.csv"
qtF <- "/home/shraddhapai/genome_annotation/Brain_eQTL_list_190326.txt"

snp <- read.delim(snpFile,sep="\t",h=T,as.is=T)
qtl <- read.table(qtF,sep="\t",h=T,as.is=T)
common <- intersect(qtl$rsID,snp$rsID)
browser()
cat(sprintf("%i SNPs in common with CMC\n", length(common)))

dt <- format(Sys.Date(),"%y%m%d")

withcmc <- merge(x=snp,y=qtl2,by=c("rsID"), all.x=TRUE)
outFile <- sprintf("%s.withCMCeqtl.txt",snpFile)
write.table(withcmc,file=outFile,sep="\t",col=T,row=F,quote=F)

