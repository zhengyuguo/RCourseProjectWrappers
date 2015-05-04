suppressPackageStartupMessages(library('gCMAP'))
suppressPackageStartupMessages(library('pytools'))

table_drug = read.tsv(file_drug)
table_disease = read.tsv(file_disease)

rownames(table_drug) = table_drug[ , symbol_col]
table_drug=subset(table_drug, select = - get( symbol_col ) )

result=extremesum(table_disease, table_drug)
result=data.frame(score=result,abs_score=abs(result))
res_o=result[order(result[,2],decreasing=T),,drop=F]
write.tsv(res_o,file=output_file,row.names=T)
