#' clean up gwas catalogue fetched from targetvalidation.org

args <- commandArgs(TRUE)

### CHANGE THIS TO FILE NAME
inFile <- args[1] #"GWAShits_EFO0000618.txt"

inf <- file(inFile,"r")
ctr <- 0
out <- list()
repeat {
    ctr <- ctr+1
      cur   <- readLines(inf,n=1)
      if (length(cur)==0) break;
        cur <- strsplit(cur,"u'")[[1]][-1]
        w <- cur
      for (i in 1:length(w)) {
            x <- trimws(w[i])
            x<-gsub("',$","",x)
            x<-gsub("':$","",x)
            x<-gsub("\\{","",x)
            x<-gsub("\\}","",x)

            w[i] <- x
        }
        w <- w[c(1:3,seq(5,25,2))]
        out[[ctr]] <- w
}

out2 <- do.call("rbind",out)
out2[,3] <- sub("', $","",out2[,3])
out2[,ncol(out2)] <- sub("')$","",out2[,ncol(out2)])
colnames(out2) <- c("gene.symbol","gene.name","trait","pubmed_refs",
    "odd_ratio","object",
    "variant","study_name","sample_size","gwas_panel_resolution","datasource",
    "confidence_interval","pvalue","target")
out2 <- as.data.frame(out2,stringsAsFactor=TRUE)
out2$rsID <- sub("http:\\/\\/identifiers.org\\/dbsnp\\/","",out2$variant)
write.table(out2,file=sprintf("%s.formatted.txt",inFile),sep="\t",
    col=T,row=F,quote=F)
