#!/bin/bash

for i in {1..22} X
do
  bcftools query -i 'TYPED=1 && INFO/AC>1963 && INFO/AC<194257 && INFO/INFO>0.8' -f "%ID\n" ${i}.vcf.gz > SNPlist${i}.txt #Extract SNPs that were genotyped before imputation, frequency>0.01, imputation quality>0.8
  wait
  plink2 --bfile ${i} --keep trace_element_fid_iid.txt --extract SNPlist${i}.txt --indep-pairwise 50 5 0.5 --make-bed --out chr${i}_genotyped_pruned
done
