library(dplyr)

###args <- c("/root/annot/outdir/SQ9887_L00.reheader.vcf.gz_rsID.bed", "/root/annot/annot_sources/clinvar.bed", "/root/annot/annot_sources/GWAShits.tmp", "/root/annot/outdir/SQ9887_L00.reheader.vcf.gz_rsID.bed.openchrom.txt", "/root/annot/outdir/SQ9887_L00.reheader.vcf.gz_rsID.bed.eQTL.txt", "/root/annot/outdir/final_table.txt")

args <- commandArgs(TRUE)
vcf.intersection.Path <- args[1]
clinvarPath <- args[2]
GWAShitsPath <- args[3]
opchrom <- args[4]
epi <- args[5]
final.table.file <- args[6]

logFile <- sprintf("%s.log",final.table.file)
sink(logFile,split=TRUE)
tryCatch({
#CLINVAR
clinvar <- read.csv(clinvarPath, sep="\t", header=TRUE)
colnames(clinvar)[1] <- "gene.symbol"
colnames(clinvar)[3] <- "rsID"
#filter out -1 values
clinvar <- clinvar %>%
filter(rsID !='-1')
#add "rs" to rsID
clinvar$rsID <- paste("rs", clinvar$rsID, sep="")  
# order by rsID numerically
clinvar <- clinvar[order(clinvar$rsID),]

#GWAShits
GWAShits <- read.csv(GWAShitsPath, sep="\t", header=TRUE)
GWAShits <- GWAShits[order(GWAShits$rsID),]

#merge by 
db.join <- merge(clinvar, GWAShits, by=c("rsID", "gene.symbol"), all=T)#[c("rsID", "gene.symbol", "pvalue")]
cat(sprintf("Merging clinvar (%i rows) & GWAS hits (%i rows) = %i rows in merge\n", nrow(clinvar),nrow(GWAShits), nrow(db.join)))

# MERGE INTERSECTED VCF WITH DATABASE
vcf.intersection <- read.csv(vcf.intersection.Path, sep="\t", header=FALSE)
vcf.intersection <- vcf.intersection[c("V1", "V2", "V3", "V15")]
colnames(vcf.intersection) <- c("chr","start", "end", "rsID")

cat("* Merge dbjoin and vcf intersection\n")
final.table <- merge(db.join, vcf.intersection, by=c("rsID"),all.y=TRUE)

op <- read.delim(opchrom, sep="\t",h=F,as.is=T)
colnames(op)[1:3] <- c("chr","start","end")
colnames(op)[5:8] <- c("epi_chr","epi_start","epi_end","epi_state")
op <- op[,c(1:3,5:8)]
cat("* Merge finaltable with open chromatin\n")
final.table <- merge(x=final.table,y=op,by=c("chr","end"),all.x=TRUE)

cat("* Merge finaltable with epigenetics\n")
epi <- read.delim(epi,sep="\t",h=F,as.is=T)
colnames(epi)[1:3] <- c("chr","start","end")
colnames(epi)[5:6] <- c("eQTL_gut_tissue","eQTL_gut_gene")
epi <- epi[,c(1,3,5,6)]
final.table <- merge(x=final.table,y=epi,by=c("chr","end"),all.x=TRUE)

print(paste0("* Writing final file to", final.table.file))
write.table(final.table, file=final.table.file, row.names=FALSE, sep="\t", quote=FALSE)

has_info <- which(!is.na(final.table$eQTL_gut_gene) & !is.na(final.table$epi_state) & !is.na(final.table$pvalue))
cat(sprintf("%i SNPs are eQTLs in open chromatin, and have GWAS associations\n",length(has_info)))
info2 <- final.table[has_info,]
write.table(info2,file=sprintf("%s/informative_snps.txt",outDir),sep="\t",col=T,row=F,quote=F)

print("DONE")
},error=function(ex){
print(ex)
},finally={
sink(NULL)
})
