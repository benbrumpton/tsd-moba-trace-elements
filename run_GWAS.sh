#!/bin/bash

#Input prefix (trace element chemical symbol, e.g. Hg for mercury)
prefix=$1
phen=${prefix}.rn

#Input files (temporary paths only used during analysis on cluster)
phenoIn=../dat/data/moba_${prefix}_pheno_120122.txt
bedFile=../dat/data/chr{1:23}_genotyped_pruned.bed
bimFile=../dat/data/chr{1:23}_genotyped_pruned.bim
famFile=../dat/data/chr1_genotyped_pruned.fam
impFile=../dat/data/{1:23}_subset.bgen
sample=../dat/data/1_subset.sample
LDfile=../dat/data/LDSCORE.1000G_EUR.tab.gz
mapFile=../dat/data/genetic_map_hg19_withX.txt.gz

#Output files
imputedResults=${prefix}_BOLTLMM.imputed.results.txt
genotypeResults=${prefix}_BOLTLMM.genotyped.results.txt

bolt \
  --bed=${bedFile} \
  --bim=${bimFile} \
  --fam=${famFile} \
  --phenoFile=${phenoIn} \
  --phenoCol=${phen} \
  --covarFile=${phenoIn} \
  --qCovarCol=PC1 \
  --qCovarCol=PC2 \
  --qCovarCol=PC3 \
  --qCovarCol=PC4 \
  --qCovarCol=PC5 \
  --qCovarCol=PC6 \
  --qCovarCol=PC7 \
  --qCovarCol=PC8 \
  --qCovarCol=PC9 \
  --qCovarCol=PC10 \
  --qCovarCol=AgeSample \
  --LDscoresFile=${LDfile} \
  --LDscoresMatchBp \
  --geneticMapFile=${mapFile} \
  --lmm \
  --statsFile=${genotypeResults} \
  --bgenFile={impFile} \
  --sampleFile=${sample} \
  --statsFileBgenSnps=${imputedResults} \
  --verboseStats \
  --numTreads=1 \
