extremesum = function( disease, drug) {
    upset = disease [ disease[,] >= 0, , drop = F ]
    downset = disease [ disease[,1] < 0, , drop = F ]
    upindis = subset(drug,subset= rownames(drug) %in% rownames(upset))
    downindis = subset(drug,subset= rownames(drug) %in% rownames(downset))
    colSums(upindis)-colSums(downindis)
}
