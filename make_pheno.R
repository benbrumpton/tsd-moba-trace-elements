library(data.table)
library(foreign)
library(stringr)
library(dplyr)
library(RNOmni)

#INPUT
PCfile <- ""
INFOfile <- ""
KeyFile <- ""
TraceElementFile <- ""

PCs <- fread(PCfile)
INFO <- read.spss(INFOfile,to.data.frame=T)
TE <- read.spss(TraceElementFile,to.data.frame=T)
MoBa_mother <- read.spss(KeyFile,to.data.frame=T)

#Cleaning files
INFO$M_ID_2944 <- str_replace_all(string=INFO$M_ID_2944,pattern="\t",repl="")
INFO$M_ID_2944 <- str_replace_all(string=INFO$M_ID_2944,pattern=" ",repl="")
MoBa_mother$SENTRIX_ID <- str_replace_all(string=MoBa_mother$SENTRIX_ID,pattern="\t",repl="")
MoBa_mother$SENTRIX_ID <- str_replace_all(string=MoBa_mother$SENTRIX_ID,pattern=" ",repl="")
MoBa_mother$M_ID_2944 <- str_replace_all(string=MoBa_mother$M_ID_2944,pattern="\t",repl="")
MoBa_mother$M_ID_2944 <- str_replace_all(string=MoBa_mother$M_ID_2944,pattern=" ",repl="")
MoBa_mother$BATCH <- str_replace_all(string=MoBa_mother$BATCH,pattern="\t",repl="")
MoBa_mother$BATCH <- str_replace_all(string=MoBa_mother$BATCH,pattern=" ",repl="")

#Select only HARVEST
MoBa <- MoBa_mother[(MoBa_mother$BATCH=="HARVEST"),]


#COMBINE DATA
trace_elements <- merge(TE,INFO,by="PREG_ID_2944",all=F)
trace_elements = trae_elements[!(trace_elements$PREG_ID_2944==41735|trace_elements$PREG_ID_2944==87746),] #Remove preg IDs with no trace elements measured

#Order by age and remove duplicates (keeping the measurements from the latest pregnancies). Check if this is the most sensible thing to do.
trace_elements = trace_elements[order(trace_elements[,"M_ID_2944"],-trace_elements[,"AgeSample"]),]
trace_elements = trace_elements[!duplicated(trace_elements$M_ID_2944),]

#Merge KeyFile (MoBa) with PCs:
tmp1 <- merge(PCs,MoBa,by.x="FID",by.y="SENTRIX_ID",all=F)
tmp1 <- tmp1[!duplicated(tmp1$M_ID_2944),]

#Add trace elements
tmp2 <- merge(trace_elements,tmp1,by="M_ID_2944",all=F)
tmp2$MATID <- 0
tmp2$PATID <- 0

#Create one phenofile per trace element and inverse rank normalize residuals

Mn_pheno <- tmp2[,c("FID","IID","MATID","PATID","Mn_Mangan","AgeSample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10")]
Mn_pheno <- na.omit(Mn_pheno)
regr <- lm(Mn_Mangan~AgeSample,Mn_pheno)
residuals <- resid(regr)
Mn_pheno$Mn.rn <- RankNorm(residuals)

write.table(Mn_pheno[,c(1:4,6:17)],"moba_Mn_pheno_120122.txt",quote=F,sep="\t",col.names=T,row.names=F)

#Repeat for the other trace elements


