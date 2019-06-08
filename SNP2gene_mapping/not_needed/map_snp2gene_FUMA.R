# Compiles snp-gene mappings from all resources into single format suitable
# for gengeno
rm(list=ls())
require(reshape2)
require(parallel)
require(doParallel)
require(foreach)

inDir <- "/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/output"
gtex <- sprintf("%s/GTEx_Brain_anno_CortexHipp_190205_STRICT.txt",inDir)
gtexTPMFile <- "/home/shraddhapai/genome_annotation/GTEx/GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_median_tpm.gct"
hic <- sprintf("%s/../hic/PNC_snps.homer.unique.enh.TPMfiltered.bed",inDir)
annovar <- sprintf("%s/annovar.hg19_multianno.txt",inDir)

dt <- format(Sys.Date(),"%y%m%d")
final_outFile <- sprintf("%s/snp2gene_brainFiltered_GTEXstrict_%s.txt",inDir,dt)

xpr <- read.delim(gtexTPMFile,sep="\t",h=T,as.is=T)
tpm <- log2(xpr$Brain...Cortex)
idx <- which(tpm>1)
brain <- unique(xpr[idx,2])
cat(sprintf("GTEx: %i genes with log2(TPM)>1)",length(brain)))


pn <- function(x) { prettyNum(x,big.mark=",")}

logFile <- sprintf("%s/map_snp2gene_%s.log",inDir,dt)

sink(logFile,split=TRUE)
tryCatch({
	out <- list()
	cat("GTEX")
	g <- read.delim(gtex,sep="\t",h=T,as.is=T)
	g <- g[which(rowSums(is.na(g[,-1]))<(ncol(g)-1)),]
	g <- na.omit(melt(g,id.vars="snp"))
	outFile <- sprintf("%s/gtex_%s.out",inDir,dt)
	colnames(g) <- c("snp","brain_region","gene")
	g$gene <- gsub(";",",",g$gene)
	write.table(g,file=outFile,sep="\t",col=T,row=F,quote=F)
	out[["gtex"]] <-g[,c("snp","gene")]
	rm(g)
	
	
cat("Update to match fuma\n"
	cat("HiC\n")
	t0 <- Sys.time()
	hic <- read.delim(hic,sep="\t",h=F,as.is=T)
	print(Sys.time()-t0)
	colnames(hic) <- c("snp","gene")
	out[["hic"]] <- hic

	cat("merging\n")
	out <- lapply(out,function(x) { rownames(x) <- NULL; x})
	mega <- do.call("rbind",out)
	rownames(mega) <- NULL
	mega <- mega[!duplicated(mega),]
	old_out <- out

	print(lapply(old_out,nrow))
	
	# collapse snp-genes
	out <- list()
	ctr <- 1
	mega <- mega[order(mega[,1]),]
	cur_snp <- mega[ctr,1]
	cur_gene <- NULL
	t0 <- Sys.time()
	while (ctr <= nrow(mega)) {
		if (ctr %% 10000==0) cat(".")
		if (cur_snp == mega[ctr,1]) {
			cur_gene <- c(cur_gene, mega[ctr,2])
		} else { # new snp
			if (length(cur_gene)>1) {
				cur_gene <- unique(cur_gene)
				cur_gene <- paste(cur_gene,collapse=",")
			}
			
			out[[length(out)+1]] <- c(cur_snp,cur_gene)
			cur_gene <- mega[ctr,2] # start new gene list for this snp
		}
		cur_snp <- mega[ctr,1]
		ctr <- ctr+1
	}

	t1 <- Sys.time()
	cat(sprintf("Time taken\n"))
	print(t1-t0)
	out <- do.call("rbind",out)
	cat(sprintf("%s SNPs covered\n", pn(nrow(out))))
	
	out <- cbind(out,dist=0)
	out <- as.data.frame(out,stringsAsFactors=FALSE)
	colnames(out) <- c("V1","V2","V3")
	
	outFile <- final_outFile
	write.table(out,file=outFile,sep="\t",col=F,row=F,quote=F)

	# now get old snp-gene mappings
	old <- read.delim("/home/shraddhapai/BaderLab/2015_PNC/output/gcta/gsea/pnc_snp_info_hg19.txt.out",
		sep="\t",h=F,as.is=T)
cat("Change cutoff to 10kb\n")
browser()
	lo <- setdiff(old[,1],out[,1])
	cat(sprintf("%s snps not mapped by anno; keeping positional info\n",
		pn(length(lo))))
	out2 <- rbind(out, old[which(old[,1]%in%lo),])
	cat(sprintf("Final snp-gene map has %s snps\n", pn(nrow(out2))))
	
	outFile <- sub(".txt","_withposinfo.txt",outFile)
	write.table(out2,file=outFile,sep="\t",col=F,row=F,quote=F)
},error=function(ex){
	print(ex)
},finally={
	sink(NULL)
})
