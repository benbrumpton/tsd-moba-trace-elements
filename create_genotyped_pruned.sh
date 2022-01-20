#!/bin/bash

for i in {1..22} X
do
  bcftools query -f "%ID\t%FORMAT/ID\t%INFO/INFO\t%INFO/AC\n" ${i}.vcf.gz | awk '$2=="TYPED" && $3>0.99 && $4>1963 && $4<194257 {print $1}' > SNPlist${i}.txt
done
wait

for i in {1..22} X
do plink2 --bfile ${i} --keep trace_element_fid_iid.txt --extract SNPlist${i}.txt --indep-pairwise 50 5 0.3 --make-bed --out chr${i}_pruned
done
