#!/bin/bash

plink --merge-list files_to_merge.txt --make-bed --out all_chr_genotyped_pruned #Merges files created by create_genotyped_pruned.sh
wait
plink2 --bfile all_chr_genotyped_pruned --king-cutoff 0.125 #Makes list of IDs with no second degree relatives or closer, for using when running plink on unrelated samples
