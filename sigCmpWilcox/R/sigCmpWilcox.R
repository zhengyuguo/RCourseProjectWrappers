suppressPackageStartupMessages(library('gCMAP'))
suppressPackageStartupMessages(library('pytools'))

table_drug = read.tsv(file_drug)
table_disease = read.tsv(file_disease)

rownames(table_drug) = table_drug[ , symbol_col]
table_drug=subset(table_drug, select = - get( symbol_col ) )

disease_cmap = CMAPCollection(as.matrix(table_disease))
drug_cmap = CMAPCollection(as.matrix(table_drug))


disease_cmap = induceCMAPCollection(disease_cmap, higher=zthr, lower=-zthr, element="members")
drug_cmap = induceCMAPCollection(drug_cmap, higher=1e-16, lower=-1e-16, element="members")
result=cmapTable(wilcox_score(disease_cmap, drug_cmap,element="members"))
write.tsv(result,file=output_file)
