#' group genes by associated snps
#'
#' @param x (data.frame) SNP column has rsID, gene column has gene symbol. 
#' There could be multiple rows per snp
collapse_snpgenes <- function(x,numCores=8) {

require(doParallel)
require(foreach)

uqsnp=unique(x$snp)
cl	<- makeCluster(numCores,outfile=sprintf("collapse_snp2gene.txt"))
registerDoParallel(cl)

t0 <- Sys.time()
out <- foreach (cur=uqsnp) %dopar% {
	print(cur)
	blah <- subset(x, snp %in% cur)
	gn <- paste(blah$gene,collapse=",")
	cbind(cur,gn)			
}
t1 <- Sys.time()
cat(sprintf("Time to collapse snp-gene\n"))
print(t1-t0)
	stopCluster(cl)

	out <- do.call("rbind",out)
	colnames(out) <- c("snp","genes")
	out
}

