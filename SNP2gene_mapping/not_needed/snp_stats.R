# SNP breakdown by functional significance
rm(list=ls())

inFile <- "/Users/shraddhapai/Dropbox/netDx/BaderLab/2015_PNC/output/gcta/gcta_181022/nocovar_mlma_190226/merged_variants_1e5_190422.tsv_formated.tsv"
dat <- read.delim(inFile,sep="\t",h=T,as.is=T)

tot <- length(unique(dat$rsID))

cat(sprintf("%i rows\n",nrow(dat)))
dat <- dat[!duplicated(dat),]
cat(sprintf("After dedup: %i rows\n",nrow(dat)))

func <- subset(dat, BM_SNP_fun_consequence_Variant.consequence !="")
cat(sprintf("\tSNP consequence = %i\n", length(unique(func$rsID))))
uq <- length(unique(func$rsID))
cat(sprintf("\t\t%1.1f %%\n", (uq/tot)*100))

func2 <- subset(func,BM_SNP_fun_consequence_Variant.consequence %in% c("missense_variant", "splice_region_variant"))
cat(sprintf("\tMissense/splice = %i\n", length(unique(func2$rsID))))
uq <- length(unique(func2$rsID))
cat(sprintf("\t\t%1.1f %%\n", (uq/tot)*100))

ep <- subset(dat, brain_enhancers_match!="" | brain_promoters_match !="")
cat(sprintf("\tBrain e/p = %i\n", length(unique(ep$rsID))))
uq <- length(unique(ep$rsID))
cat(sprintf("\t\t%1.1f %%\n", (uq/tot)*100))

fet <- subset(dat, OBrien_fetal_eqtl_SYMBOL != "")
cat(sprintf("\tFetal brain eQTL = %i\n", length(unique(fet$rsID))))
uq <- length(unique(fet$rsID))
cat(sprintf("\t\t%1.1f %%\n", (uq/tot)*100))

cmc <- subset(dat, CMC_disease_Gene_symbol!="")
cat(sprintf("\tCMC eQTL = %i\n", length(unique(cmc$rsID))))
uq <- length(unique(cmc$rsID))
cat(sprintf("\t\t%1.1f %%\n", (uq/tot)*100))

gtex <- subset(dat, gtex_v7_symbol != "")
cat(sprintf("\tGTEx eQTL = %i\n", length(unique(gtex$rsID))))
uq <- length(unique(gtex$rsID))
cat(sprintf("\t\t%1.1f %%\n", (uq/tot)*100))

x <- subset(dat, gtex_v7_symbol !="" | BM_SNP_fun_consequence_Variant.consequence != "" | OBrien_fetal_eqtl_SYMBOL !="" | brain_promoters_match !="" | brain_enhancers_match != "" | psychENCODE_fQTL_Category !="")
cat(sprintf("\tAny function (exc. CMC) = %i\n", length(unique(x$rsID))))
uq <- length(unique(x$rsID))
cat(sprintf("\t\t%1.1f %%\n", (uq/tot)*100))

y <- subset(dat, gtex_v7_symbol !="" | BM_SNP_fun_consequence_Variant.consequence != "" | OBrien_fetal_eqtl_SYMBOL !="" | brain_promoters_match !="" | brain_enhancers_match != "" | psychENCODE_fQTL_Category !="" | CMC_disease_Gene_symbol!="")
cat(sprintf("\tAny function (inc. CMC) = %i\n", length(unique(y$rsID))))
uq <- length(unique(y$rsID))
cat(sprintf("\t\t%1.1f %%\n", (uq/tot)*100))

dt <- format(Sys.Date(),"%y%m%d")

# SNP breakdown by function
stats <- c(length(unique(func$rsID)),length(unique(func2$rsID)),length(unique(ep$rsID)),length(unique(fet$rsID)),length(unique(gtex$rsID)),length(unique(cmc$rsID)),length(unique(y$rsID)))
stats <- (stats/tot)*100
names(stats) <- c("Nonsyn","Splice/missense","Brain enh-prom","Fetal brain eQTL",
	"GTEx","CMC","Any")
clr <- rep("grey50",length(stats))
clr[length(clr)] <- "darkred"
pdf(sprintf("snp_breakdown_func_%s.pdf",dt))
par(mar=c(10,4,3,3))
barplot(stats,las=2,cex.axis=1.5,border=NA,cex.lab=1.5,ylim=c(0,40))
dev.off()

# plot snp breakdown by pheno
clr <- dat[,c("pheno_name","pheno_color")]
clr <- clr[!duplicated(clr),]
tmp <- dat[!duplicated(dat[,c("rsID","pheno_name")]),]
tbl <- table(tmp$pheno_name)
tbl <- tbl[c(9,1,5,3,8,7,4,6,2)]
idx <- match(names(tbl),clr$pheno_name)
clr2 <- clr[idx,]

names(tbl) <- substr(names(tbl),1,regexpr("\\(",names(tbl))-2)
names(tbl) <- sub(" ","\n",names(tbl))

pdf(sprintf("pheno_snp_breakdown_%s.pdf",dt),width=3,height=3)
tryCatch({
par(mar=c(6,3,1,1))
barplot(tbl,col=clr2[,2],las=2,cex.axis=0.8,ylab="Num. SNPs (p<10-5)",
	border=NA,cex=0.8,cex.lab=0.8)
print(sum(tbl))
},error=function(ex){print(ex)
},finally={dev.off()}
)




