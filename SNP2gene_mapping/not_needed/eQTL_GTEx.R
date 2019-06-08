

# map snps to gtex
inDir <- "/home/shraddhapai/genome_annotation/GTEx/GTEx_Analysis_v7_eQTL"

snpFile <- "/home/shraddhapai/BaderLab/2015_PNC/output/gcta/nocovar_mlma_190226/merged_variants_1e5_190411.tsv_formated.tsv"

# must have genes column in both
.addToDF <- function(g,newdat, col2add="genes") {
	newdat <- subset(newdat, genes %in% g$genes)
	if (nrow(newdat)>=1) {
		tmp <- newdat[,c("genes",col2add)]
		colnames(tmp)[2] <- "newcol"
		g <- merge(x=g,y=tmp,by="genes",all.x=TRUE)
	
	#	midx <- match(newdat$genes,g$genes)
	#	if (any(midx)) g$newcol[midx] <- newdat[,col2add]
	}
	return(g)
}

# ------------------------
snp <- read.delim(snpFile,sep="\t",h=T,as.is=T)
samps <- c("Brain_Cortex","Brain_Frontal_Cortex_BA9","Brain_Hippocampus","Brain_Anterior_cingulate_cortex_BA24")
for (cur in samps) {
	fName <- sprintf("%s/%s.v7.egenes.txt.gz",inDir,cur)
	dat <- read.delim(fName,sep="\t",h=T,as.is=T)
	dat <- subset(dat,qval<0.05)
	dat <- dat[,c("rs_id_dbSNP147_GRCh37p13","gene_name","ref","alt","slope")]
	colnames(dat)[1] <- "rsID"
	colnames(dat)[-1] <- paste(sprintf("GTEx.%s",cur),colnames(dat)[-1],sep=".")
	snp <- merge(x=snp,y=dat,by="rsID",all.x=TRUE)
}

dt <- format(Sys.Date(),"%y%m%d")
write.table(snp,file=sprintf("%s.GTEx.txt",snpFile),sep="\t",col=T,row=F,quote=F)



