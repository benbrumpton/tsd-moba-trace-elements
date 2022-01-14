#!/bin/bash

#Input prefix (trace element chemical symbol, e.g. Hg for mercury)
prefix=$1
phen=${prefix}.rn

#Input files (temporary paths only used during analysis on cluster)
phenoIn=$SCRATCH/dat/moba_${prefix}_pheno_120122.txt
genoFile=$SCRATCH/dat/{1:23}
impFile=$SCRATCH/dat/{1:23}.bgen
sample=$SCRATCH/dat/{1:23}.sample
LDfile=$SCRATCH/dat/LDSCORE.1000G_EUR.tab.gz
mapFile=$SCRATCH/dat/genetic_map_hg19_withX.txt.gz

#Output files
imputedResults=${prefix}_BOLTLMM.imputed.results.txt
genotypeResults=${prefix}_BOLTLMM.genotyped.results.txt

bolt \
  --bfile=${genoFile} \
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
  --LDscoresMatchPb \
  --geneticMapFile=${mapFile} \
  --lmm \
  --statsFile=${genotypeResults} \
  --bgenFile={impFile} \
  --sampleFile=${sample} \
  --statsFileBgenSnps=${imputedResults} \
  --verboseStats \
  --numTreads=1 \
