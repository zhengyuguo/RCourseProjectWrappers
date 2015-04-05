suppressPackageStartupMessages(library(limma))
suppressPackageStartupMessages(library(pytools))

phenoData=read.tsv(sampletable)
rownames(phenoData)=phenoData[,samplecol]
phenoData=phenoData[,phenocol,drop=F]

arrays=read.maimages(files=rownames(phenoData), path=data_dir,green.only=T,source='agilent')
arrays <- backgroundCorrect(arrays, method="normexp", offset=16)
arrays <- normalizeBetweenArrays(arrays, method="quantile")
arrays.ave <- avereps(arrays, ID=arrays$genes$ProbeName)

condition_factor=factor(phenoData[,phenocol])
design=model.matrix(~condition_factor)
colnames(design)=c(levels(condition_factor)[1],paste(levels(condition_factor),collapse='vs'))
fit=lmFit(arrays.ave, design)
fit=eBayes(fit)
rowN=dim(arrays.ave)[1]
tab=topTable(fit,adjust.method='BH',coef=2,p.value=1,n=rowN)
saveRDS(tab,file=outfile)
