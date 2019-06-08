#' assign snps to genes 

inDir <- "/home/shraddhapai/BaderLab/2015_PNC/anno/map_snp2gene"
snpFile <- "/home/shraddhapai/BaderLab/2015_PNC/input/impute/merge_info0.6/all_chroms/PNC_imputed_merged.CLEAN_CEUTSI_5sd_FINAL.bim"

hic <- read.delim(sprintf("%s/snp2gene.HIC.bed",inDir),sep="\t",h=F,as.is=T)
eqtl <- read.delim(sprintf("%s/snp2gene.EQTLS.bed",inDir),sep="\t",h=F,as.is=T)
pos <- read.delim(sprintf("%s/snp2gene.POS.bed",inDir),sep="\t",h=F,as.is=T)

dt <- format(Sys.Date(),"%y%m%d")
# you were making a log file and were going to run the job.

eqtl <- eqtl[,c(4,5)]
eqtl <- eqtl[!duplicated(eqtl),]
pos <- pos[,c(4,8)]
pos <- pos[!duplicated(pos),]

snps <- read.table(snpFile,sep="\t",h=F,as.is=T)

gene_map <- rep(NA, nrow(snps))
src <- rep(NA,nrow(snps))

idx  <- which(snps[,2] %in% eqtl[,1])
cat(sprintf("%i snps in eqtls\n", length(idx)))
midx <- match(snps[idx,2],eqtl[,1])
gene_map[idx] <- eqtl[midx,2]
src[idx] <- rep("eqtl",length(idx))

idx <- which(snps[,2] %in% hic[,1])
idx <- setdiff(idx, which(!is.na(gene_map)))
cat(sprintf("%i snps in hic and not eqtl\n", length(idx)))
midx <- match(snps[idx,2],hic[,1])
gene_map[idx] <- hic[midx,2]
src[idx] <- rep("hic",length(idx))

idx <- which(snps[,2] %in% pos[,1])
idx <- setdiff(idx, which(!is.na(gene_map)))
cat(sprintf("%i snps match by pos\n", length(idx)))
midx <- match(snps[idx,2],pos[,1])
gene_map[idx] <- pos[midx,2]
src[idx] <- rep("pos", length(idx))

cat(sprintf("%i snps no mapping\n",sum(is.na(gene_map))))

newmap <- cbind(snps[,2],gene_map,src)
newmap <- na.omit(newmap)
outFile <- sprintf("%s/snp2gene.COMBINED.withsrc.txt",inDir)
write.table(newmap,file=outFile,sep="\t",col=FALSE,row=FALSE,quote=FALSE)
outFile <- sprintf("%s/snp2gene.COMBINED.txt",inDir)
newdat <- cbind(newmap[,1:2],0)
write.table(newdat,file=outFile,sep="\t",col=F,row=F,quote=F)

