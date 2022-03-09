#!/bin/bash

#Input prefix (Chemical element)
prefix=$1
phen=${prefix}.rn
#Chromosome number: 1-22, X (used by slurm job script)
chrom=$2

#Input files (temporary paths used during analysis on cluster)
phenoFile=../dat/data_plink/moba_${prefix}_pheno_120122_plink.txt
covarFile=../dat/data_plink/moba_trace_element_covars_120122.txt

genoFile=../dat/data_plink/chr${chrom}_moba

#Output files
resFile=chr${chrom}_${prefix}
plink2 \
	--bfile ${genoFile}	\
	--ci 0.95	\
	--pheno ${phenoFile}	\
	--covar ${covarFile}	\
	--covar-variance-standardize	\
	--glm	\
  	--out ${resFile}	\


