# map SNPs to GTEx
source("collapse_snpgenes.R")

# PNC SNPs
snpFile="/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim..cmc.txt" 
gtexDir <- "/home/shraddhapai/genome_annotation/GTEx/GTEx_Analysis_v7_eQTL"
fList <- dir(path=gtexDir,pattern="egenes.txt.gz$")
snps <- read.delim(snpFile,sep="\t",h=T,as.is=T)[,1]

STRICT <- TRUE

outDir <- dirname(snpFile)
dt <- format(Sys.Date(),"%y%m%d")
outFile <- sprintf("%s/GTEx_Brain_anno_CortexHipp_%s.txt",outDir,dt)
if (STRICT) {
	cat("*** STRICT mode ***\n")
	outFile <- sub(".txt","_STRICT.txt",outFile)
}

out <- list()
for (fName in fList) {
	print(fName)
	dat <- read.delim(sprintf("%s/%s",gtexDir,fName),sep="\t",h=T,as.is=T)
	if (STRICT) {
		dat <- subset(dat, qval <= 0.05)
	}
	
	tmp <- dat[,c("rs_id_dbSNP147_GRCh37p13","gene_name")]
	colnames(tmp) <- c("snp","gene")
	tmp <- collapse_snpgenes(tmp)
	curf <- sub(".v7.egenes.txt.gz","",fName)
	out[[curf]] <- tmp[match(snps,tmp[,1]),2]
}

mega_out <- do.call("cbind",out)
colnames(mega_out) <- names(out)
mega_out <- cbind(snp=snps,mega_out)

not_na <- rowSums(!is.na(mega_out[,-1]))
cat(sprintf("%i of %i SNPs are GTEx cis eQTLs\n", 
	sum(not_na>0),length(snps)))

write.table(mega_out,file=outFile,sep="\t",col=T,row=F,quote=F)
