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
resFile=chr${chrom}
plink2 \
	--bfile ${genoFile}	\
	--pheno ${phenoFile}	\
	--covar ${covarFile}	\
	--mac 10	\
	--glm	hide-covar omit-ref cols=chrom,pos,ref,alt,a1freq,nobs,orbeta,se,p	\
  	--out ${resFile}	\
