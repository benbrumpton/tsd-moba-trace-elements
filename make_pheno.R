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


#Rename variables
tmp2$Mn.Manganese <- tmp2$Mn_Mangan
tmp2$Co.Cobalt <- tmp2$Co_Kobalt
tmp2$Cu.Copper <- tmp2$Cu_Kobber
tmp2$Zn.Zinc <- tmp2$Zn_Sink
tmp2$As.Arsenic <- tmp2$As_Arsen
tmp2$Se.Selenium <- tmp2$Se_Selen
tmp2$Mo.Molybdenum <- tmp2$Mo_Molybdeno
tmp2$Cd.Cadmium <- tmp2$Cd_Kadmium
tmp2$Tl.Thallium <- tmp2$Tl_Tallium
tmp2$Pb.Lead <- tmp2$Pb_Bly
tmp2$Hg.Mercury <- tmp2$Hg_total

element_names <- c("Mn.Manganese","Co.Cobalt","Cu.Copper","Zn.Zinc","As.Arsenic","Se.Selenium","Mo.Molybdenum","Cd.Cadmium","Tl.Thallium","Pb.Lead","Hg.Mercury")

#Create one phenofile for each trace element (rank transformed to normality)
library(RNOmni)
for (i in 1:length(element_names)){
  trace_element <- element_names[i]
  fields <- c("FID","IID","MATID","PATID","AgeSample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10",trace_element)
  pheno <- tmp2[,fields]
  pheno <- na.omit(pheno)
  
  #Rank transform to normality (equivalent of rntransform)
  regr <- lm(pheno[,trace_element]~pheno$AgeSample)
  residuals <- resid(regr)
  
  twoletter <- substr(trace_element,1,2)
  outname <- paste0(twoletter,".rn")
  
  pheno[,outname] <- RankNorm(residuals)
  write.table(pheno[,c(1:15,17)],paste0("moba_",twoletter,"_pheno_120122.txt"),quote=F,sep="\t",col.names=T,row.names=F)
}

#Create summary table with distributions of trace elements before transformations:
library(tidyr)
df.sum <- tmp2 %>% select(element_names) %>% summarize_each(funs(min=min(.,na.rm=T),q25=quantile(.,0.25,na.rm=T),median=median(.,na.rm=T),q75=quantile(.,0.75,na.rm=T),max=max(.,na.rm=T),mean=mean(.,na.rm=T),sd=sd(.,na.rm=T),n=length(which(!is.na(.))) ))
dim(df.sum)

df.stats.tidy <- df.sum %>% gather(stat,val) %>%
    separate(stat,into=c("element","stat"),sep="_") %>%
    spread(stat,val) %>%
    select(element,min,q25,median,q75,max,mean,sd,n)

df.stats.tidy$element <- substring(df.stats.tidy$element,4)

write.table(df.stats.tidy,"MOBA_trace_element_distributions.txt",quote=F,sep="\t",col.names=T,row.names=F)


#Mn_pheno <- tmp2[,c("FID","IID","MATID","PATID","Mn_Mangan","AgeSample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10")]
#Mn_pheno <- na.omit(Mn_pheno)
#regr <- lm(Mn_Mangan~AgeSample,Mn_pheno)
#residuals <- resid(regr)
#Mn_pheno$Mn.rn <- RankNorm(residuals)
#
#write.table(Mn_pheno[,c(1:4,6:17)],"moba_Mn_pheno_120122.txt",quote=F,sep="\t",col.names=T,row.names=F)


