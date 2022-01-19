#!/bin/bash

for i in {1..22} X
do
  bcftools query -f "%ID\t%INFO/INFO\t%INFO/AC\n" ${i}.vcf.gz | awk '$2>0.99 && $3>1963 && $3<194257 {print $1}' > SNPlist${i}.txt
done

