library(sqldf)
require(date)
library(GeneNet)
library(Rgraphviz)
library(graph)
library(vars)

# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(c("graph","Rgraphviz"))


dir <- "C:/Users/SET_YOUR_DIRECTORY"

########## Construct DataBase ##########

# seg <- read.csv(file=paste0(dir,"/Segurador.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
# banc <- read.csv(file=paste0(dir,"/Bancario.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
# con <- read.csv(file=paste0(dir,"/Construcao.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
# ene <- read.csv(file=paste0(dir,"/Energetico.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
# quim <- read.csv(file=paste0(dir,"/Quimico.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
# farm <- read.csv(file=paste0(dir,"/Farmaceutico.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
# imob <- read.csv(file=paste0(dir,"/Imobiliario.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
# var <- read.csv(file=paste0(dir,"/Varejo.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
# auto <- read.csv(file=paste0(dir,"/Automobilistico.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
# 
# 
# seg_datas <- sqldf("select Data from seg where Abertura > 0")
# banc_datas <- sqldf("select Data from banc where Abertura > 0")
# con_datas <- sqldf("select Data from con where Abertura > 0")
# ene_datas <- sqldf("select Data from ene where Abertura > 0")
# quim_datas <- sqldf("select Data from quim where Abertura > 0")
# farm_datas <- sqldf("select Data from farm where Abertura > 0")
# imob_datas <- sqldf("select Data from imob where Abertura > 0")
# var_datas <- sqldf("select Data from var where Abertura > 0")
# auto_datas <- sqldf("select Data from auto where Abertura > 0")
# 
# 
# Datas <- sqldf("select a.*
#                from seg_datas a inner join banc_datas b
#                on a.Data = b.Data
#                inner join con_datas c
#                on b.Data = c.Data
#                inner join ene_datas d
#                on c.Data = d.Data
#                inner join quim_datas e
#                on d.Data = e.Data
#                inner join farm_datas f
#                on e.Data = f.Data
#                inner join imob_datas g
#                on f.Data=g.Data
#                inner join var_datas h
#                on g.Data = h.Data
#                inner join auto_datas i
#                on h.Data = i.Data")
# 
# 
# Seguradoras <- sqldf("select Fechamento from seg where Data in Datas")
# Bancario <- sqldf("select Fechamento from banc where Data in Datas")
# Energetico <- sqldf("select Fechamento from ene where Data in Datas")
# Imobiliario <- sqldf("select Fechamento from imob where Data in Datas")
# Construcao <- sqldf("select Fechamento from con where Data in Datas")
# Farmacia <- sqldf("select Fechamento from farm where Data in Datas")
# Quimica <- sqldf("select Fechamento from quim where Data in Datas")
# Varejo <- sqldf("select Fechamento from var where Data in Datas")
# Automobilistica <- sqldf("select Fechamento from auto where Data in Datas")
# 
# 
# logretornos_seg = diff(log(Seguradoras$Fechamento))
# logretornos_banc = diff(log(Bancario$Fechamento))
# logretornos_con = diff(log(Construcao$Fechamento))
# logretornos_ene = diff(log(Energetico$Fechamento))
# logretornos_quim = diff(log(Quimica$Fechamento))
# logretornos_farm = diff(log(Farmacia$Fechamento))
# logretornos_imob = diff(log(Imobiliario$Fechamento))
# logretornos_var = diff(log(Varejo$Fechamento))
# logretornos_auto = diff(log(Automobilistica$Fechamento))
# 
# 
# data<-cbind(logretornos_seg,logretornos_banc,logretornos_ene,logretornos_imob,logretornos_con,logretornos_farm,logretornos_quim,logretornos_var,logretornos_auto)
# data<-as.data.frame(data)
# names(data)<-c("Seguradoras","Bancario","Energetico","Imobiliario","Construcao","Farmacia","Quimica","Varejo","Automobilistica")

# write.csv2(data,file=paste0(dir,"/dados_tratados.csv"))
# write.csv2(Datas,file=paste0(dir,"/Datas.csv")")

########## Reading DataBase ##########
dados <- read.csv(file=paste0(dir,"/dados_tratados.csv"),header = TRUE,sep = ";",dec=",",strip.white=TRUE)
dados <- dados[,c("Seguradoras","Bancario","Energetico","Imobiliario","Construcao","Farmacia","Quimica","Varejo","Automobilistica")]
# attach(dados)

data<-dados
data<-as.data.frame(data)
# names(data)
head(data)

########## Define Periods for the DBNs ##########
per1 <- data[c(1:13),] #14/02/2000 - 09/03/2000
per2 <- data[c(1:654),] # + 10/03/2000 - 09/10/2002
per3 <- data[c(1:1369),] # + 10/10/2002 - 22/08/2005
per4 <- data[c(1:1413),] # + 23/08/2005 -	02/11/2005
per5 <- data[c(1:1828),] # + 03/11/2005 - 23/07/2007
per6 <- data[c(1:2238),] # + 24/07/2007 - 13/03/2009
per7 <- data[c(1:2467),] # + 14/03/2009 - 07/02/2010
per8 <- data[c(1:3171),] # + 08/02/2010 -	30/11/2012
per9 <- data[c(1:3629),] # + 01/12/2012 -	29/09/2014
per10 <- data[c(1:3974),] # + 30/09/2014 - 11/02/2016
per11 <- data[c(1:4154),] # + 12/02/2016 - 27/10/2016
per12 <- data[c(1:4188),] # + 28/10/2016 - 15/12/2016
per13 <- data[c(1:4354),] # + 16/12/2016 - 16/08/2017
per14 <- data[c(1:4373),] # + 17/08/2017 - 13/09/2017
per15 <- data[c(1:4503),] # + 14/09/2017 - 21/03/2018
per16 <- data[c(1:4789),] # + 22/03/2018 - 10/05/2019
per17 <- data[c(1:4987),] # + 11/05/2019 - 24/02/2020
per18 <- data[c(1:5069),] # + 25/02/2020 - 10/06/2020
per19 <- data[c(1:5138),] # + 25/02/2020 - 30/09/2020

########## Estimate DBNs ##########
Per1 <- as.matrix(per19)  ## Insert the period to be estimated
Per1 <- as.longitudinal(Per1)
# summary(Per1)
# plot(Per1,1:9)

rede1 <- ggm.estimate.pcor(Per1, method = "dynamic")
rede1
rede_1 <- network.test.edges(rede1, direct=TRUE, fdr=TRUE)
rede_1

## Define the relevant parameters and extract the Networks

rede_1 = extract.network(rede_1, method.ggm=c("qval"), cutoff.ggm=0.1, method.dir=c("all"), verbose=TRUE)
dim(rede_1)
grafico1 <- network.make.graph(rede_1, node.labels=c("Insurance","Banking","Oil & Gas","Real State","Construction","Pharmacy","Chemistry","Retail","Automotive"), drop.singles=FALSE)
grafico1
edge.info(grafico1)
table(edge.info(grafico1)$dir)
sort(node.degree(grafico1), decreasing=TRUE)

## Define plot configurations
globalAttrs = list()
globalAttrs$edge = list(color = "black", lty = "solid", lwd = 1,fontsize=18)
globalAttrs$node = list(fillcolor = "lightblue", shape = "ellipse", fontsize=30)

edi = edge.info(grafico1)
edgeAttrs = list()
edgeAttrs$dir = edi$dir # set edge directions
edgeAttrs$lty = ifelse(edi$weight < 0, "dotted", "solid") # negative correlation -> dotted
edgeAttrs$color = ifelse(edi$dir == "none", "black", "red")
edgeAttrs$label = round(edi$weight, 2) # use partial correlation as edge labels

## Plot the DBN
plot(grafico1, attrs = globalAttrs, edgeAttrs = edgeAttrs, "fdp")


### Evaluate stationarity
var.2c <- VAR(per19, p = 1)
roots(var.2c)
serial.test(var.2c, lags.pt = 16, type = "PT.adjusted")
normality.test(var.2c)
