#' take leading edge snp-gene combinations and find eQTLs in GTEx or CMC

inFile <- "/home/shraddhapai/BaderLab/2015_PNC/output/gcta/gengen_gsea/snpanno_FUMA_190403/leadingEdges.Qlt0.1.geneTallySNP.txt"
gtexDir <- "/home/shraddhapai/genome_annotation/GTEx/GTEx_Analysis_v7_eQTL"

fList <- dir(path=gtexDir,"egenes.txt.gz$")
dat <- read.delim(inFile,sep="\t",h=T,as.is=T)

for (nm in fList) {
	fn <- sprintf("%s/%s", gtexDir,nm)
	print(fn)
	cur <- read.delim(fn,sep="\t",h=T,as.is=T)
	cur <- subset(cur,qval < 0.05)
	cur <- cur[,c("rs_id_dbSNP147_GRCh37p13","gene_name")]
	dat$newcol <- rep("",nrow(dat))
	cur <- subset(cur, gene_name %in% dat$leadingEdgeGene &
			rs_id_dbSNP147_GRCh37p13 %in% dat$snp)
	cat(sprintf("%i matches\n",nrow(cur)))
	if (nrow(cur)>=1) {
		print(cur)
		tgt <- paste(dat$gene_name,dat$snp,sep=".")
		src <- paste(cur$genes,cur$rs_id_dbSNP147_GRCh37p13,sep=".")
		midx <- match(src,tgt)
		if (any(midx)) dat$newcol[midx] <- "Yes"
	} 
	tis <- sub(".v7.egenes.txt.gz","",basename(fn))
	colnames(dat)[ncol(dat)] <- tis

}


