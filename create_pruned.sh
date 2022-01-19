#!/bin/bash

for i in {1..22} X
do
  plink2 --bfile --keep trace_element_fid_iid.txt --extract SNPlist${i}.txt --indep-pairwise 50 5 08 --make-bed --out chr${i}_pruned
done
