#!/bin/bash

#Combining results from running plink separately on each chromosome for As and Mo
awk '
    FNR==1 && NR!=1 {while (/^#CHROM/) getline;}
    1 {print}
' chr*.As.rn.glm.linear > all_chr.As.rn.glm.linear.txt

awk '
    FNR==1 && NR!=1 {while (/^#CHROM/) getline;}
    1 {print}
' chr*.Mo.rn.glm.linear > all_chr.Mo.rn.glm.linear.txt
