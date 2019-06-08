# filter HiC snps excluding genes with log2(TPM) < 1 in brain
rm(list=ls())

hic_snpFile <- "/home/shraddhapai/BaderLab/2015_PNC/output/snp_anno/hic/PNC_snps.homer.unique.enh"
gtexTPMFile <- "/home/shraddhapai/genome_annotation/GTEx/GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_median_tpm.gct"

xpr <- read.delim(gtexTPMFile,sep="\t",h=T,as.is=T)
tpm <- log2(xpr$Brain...Cortex)
idx <- which(tpm>1)
brain <- unique(xpr[idx,2])
cat(sprintf("GTEx: %i genes with log2(TPM)>1)",length(brain)))

outFile <- sprintf("%s.TPMfiltered.bed", hic_snpFile)
system(sprintf("cat /dev/null > %s", outFile))
con <- file(hic_snpFile,open="r")
line <- readLines(con, n=1)
t0 <- Sys.time()
while (length(line)>0) {
	rec <- unlist(strsplit(line, "\t"))
	genes <- unlist(strsplit(rec[2],","))
	if (length(intersect(genes,brain))>0) {
		cat(sprintf("%s\n",line),file=outFile,append=TRUE)
	}
	line <- readLines(con,n=1)
}
cat("Time to parse file\n")
print(Sys.time()-t0)

