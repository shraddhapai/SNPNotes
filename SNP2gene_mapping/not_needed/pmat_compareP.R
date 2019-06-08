
withage <- "/home/shraddhapai/BaderLab/2015_PNC/output/gcta/covartest_mlma_190215/pmat_pc.covar_test.gcta_out_0.loco.mlma"
noage <- "/home/shraddhapai/BaderLab/2015_PNC/output/gcta/nocovar_mlma_190226/pmat_pc.gcta_out_0.loco.mlma"
noageF <- noage

noage <- read.delim(noage,sep="\t",h=T,as.is=T)
noage$pexp <- -log10(noage$p)
noage$rank <- rank(-1*noage$pexp)
withage <- read.delim(withage,sep="\t",h=T,as.is=T)
withage$pexp <- -log10(withage$p)
withage$rank <- rank(-1*withage$pexp)

noage$age_rank <- withage$rank
noage$withage_pvalue <- withage$p

tmp <- subset(noage, rank<20)
tmp <- tmp[order(tmp$rank),]
print(tmp)
outDir <- dirname(noage)
write.table(tmp,file=sprintf("%s/pmat_pc_ranking_with_agesex.txt",outDir),
	sep="\t",col=T,row=F,quote=F)

cat("Correlation of pvalues\n")
print(cor.test(noage$pexp,withage$pexp,method="spearman"))
