
# remove semicolons, collapse duplicate genes

snpFile <- "/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/output/snp2gene_ALL_ANNO_190114.txt"

snp <- read.delim(snpFile,sep="\t",h=F,as.is=T)
snp[,2] <- gsub(";",",",snp[,2])
newout <- list()
t0 <- Sys.time()
cat("collapsing unique")

require(doParallel)
require(foreach)

cl <- makeCluster(8)
registerDoParallel(cl)

out <- list()
out <- foreach (k=1:nrow(snp)) %dopar% {
	snp[k,2]  <- unique(snp[k,2])
	return(snp[k,])
}
print(Sys.time()-t0)

stopCluster(cl)
out <- do.call("rbind",out)
write.table(out,file=sprintf("%s.fixed.txt",snpFile),sep="\t",col=F,row=F,quote=F)
