suppressPackageStartupMessages(library(affy))
suppressPackageStartupMessages(library(limma))
suppressPackageStartupMessages(library(pytools))

phenoData=read.tsv(sampletable)
rownames(phenoData)=phenoData[,samplecol]
phenoData=phenoData[,phenocol,drop=F]

ab=ReadAffy(filenames=rownames(phenoData), celfile.path=data_dir,phenoData=phenoData)

eset=rma(ab,verbose=F)

ID=featureNames(eset)
Symbol=getSYMBOL(ID, annotation)
fData(eset)=data.frame(Symbol=Symbol)


condition_factor=factor(pData(eset)[,phenocol])
design=model.matrix(~condition_factor)
colnames(design)=c(levels(condition_factor)[1],paste(levels(condition_factor),collapse='vs'))
fit=lmFit(eset, design)
fit=eBayes(fit)
rowN=dim(eset)[1]
tab=topTable(fit,adjust.method='BH',coef=2,p.value=1,n=rowN)
sig=subset(tab,P.Value<0.05,select=c('Symbol','t'))
sig=do.call(
  rbind,lapply(
    split(sig, sig$Symbol)
    , function(x) { 
      n=which.max(abs(x$t))
      x[n,]
    }
    )
  )
rownames(sig)=sig$Symbol
sig$Symbol=NULL
write.tsv(tab,file=outall,row.names=T)
write.tsv(sig,file=outsig,row.names=T)
