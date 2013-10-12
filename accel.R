##Issue1: How to read contents from file(too big)
##Issue2: clustering fails on large number of rows- can we reduce rows? sequences? 
##net start mysql56 <use admin console>

#Initialize
rm(list=ls())

library(zoo,lib.loc="c:/work/R/Lib")
##Installing RMySQL from source. 
##install.packages("RMySQL",type='source',lib="c:/work/R/Lib")
library(DBI,lib.loc="c:/work/R/Lib")
library(RMySQL,lib.loc="c:/work/R/Lib")
#Following is not needed as source installation will do the job
#Rcmd.bat INSTALL RMySQL.whatever.tar.gz 
##http://stackoverflow.com/questions/4785933/adding-rmysql-package-to-r-fails
library(cluster,lib.loc="c:/work/R/Lib") 
library(mclust,lib.loc="c:/work/R/Lib")
library(flexmix,lib.loc="c:/work/R/Lib")
library(fpc,lib.loc="c:/work/R/Lib")


SequenceSignature<- function(x){
  #x contains data for a particular sequence
  cluster.count=3
  fit <- kmeans(x, cluster.count)
  seq.clust.sign <- c(length(fit$cluster[fit$cluster==1]),length(fit$cluster[fit$cluster==2]),length(fit$cluster[fit$cluster==3]))
  seq.clust.sign*100/sum(seq.clust.sign)
}


DeviceSignature<- function(x.df,deviceId){
  #x.df contains data for a particular device(x,y,z co-ordinates)
  seq.size <-300
  seq.count <- floor(nrow(x.df)/seq.size)
  
  device.sign <- data.frame(x= numeric(0), y= numeric(0), z = numeric(0))
  for(i in 1:seq.count){
    seq.start <-1+(i-1)*seq.size
    seq.end <- i*seq.size
    device.seq=x.df[seq.start:seq.end,2:4]
    device.sign[i,] <- SequenceSignature(device.seq)
  }
  
  ##Issue:device.sign has data all over the place
  ##Issue:adding all rows causes all information to be lost
  col.sums <- apply(device.sign, 2, sum)
  device.sign.sum <- col.sums*100/sum(col.sums)
  
  device.sign.ret<-cbind(device.sign.sum["x"],device.sign.sum["y"],device.sign.sum["z"],deviceId)
  colnames(device.sign.ret)<-c("x","y","z","deviceId")
  
  device.sign.ret
}


DeviceSignatureList<- function(device.list){
  #device.list contains collection of devices for which we need signature
  device.sign.df <- data.frame(x= numeric(0), y= numeric(0), z = numeric(0),deviceId = integer(0))
  
  for(i in 1:length(device.list)){
    device <- device.list[i]
    device.query <- paste("select * from accel where device =",device)
    result<-dbSendQuery(mySql.con, device.query)
    accel.df<- fetch(result, n = -1)   ##a single device has 523187 rows
    device.sign <- DeviceSignature(accel.df,device)  
    device.sign.df[i,]<-device.sign
  }
  
  device.sign.df
}

DeviceSignatureAll <- function(device.count=4){
  
  result.device<-dbSendQuery(mySql.con, "select distinct device from accel");
  device.df<- fetch(result.device, n = -1)
  device.list <-device.df[1:device.count,1]
  device.sign.df <- DeviceSignatureList(device.list)
  device.sign.df
} 

TestSequenceSignAll <- function(seq.count=4){
  
  result.sequence<-dbSendQuery(mySql.con, "select distinct sequenceid from acceltest");
  sequence.df<- fetch(result.sequence, n = -1)
  sequence.list <-sequence.df[1:seq.count,1]
  
  seq.sign.df <- data.frame(x= numeric(0), y= numeric(0), z = numeric(0),sequenceId = integer(0))
  
  for(i in 1:length(sequence.list)){
    sequence.id <- sequence.list[i]
    sequence.query <- paste("select * from acceltest where sequenceid =",sequence.id)
    result.test<-dbSendQuery(mySql.con, sequence.query)
    sequence.df.test <- fetch(result.test, n = -1)
    
    seq.sign <-SequenceSignature(sequence.df.test[2:4])
    
    seq.sign.ret<-cbind(seq.sign[1],seq.sign[2],seq.sign[3],sequence.id)
    colnames(seq.sign.ret)<-c("x","y","z","sequenceId")
    
    seq.sign.df[i,]<-seq.sign.ret
  }
  
  seq.sign.df
}


#Main function
mySql.driver<-dbDriver("MySQL");
mySql.con<-dbConnect(mySql.driver,user='root',password='#bugsfor$',host='localhost',dbname='test');
device.sign.all<-DeviceSignatureAll()
seq.sign.all<-TestSequenceSignAll()

#Compare data from device.sequence and test.sequence
seq.sign.all
device.sign.all













#############################################################################################################
#############################################################################################################
#Plot time-series
plot.seq <- function(start,end){
  sample.start=start
  sample.end=end
  accel.zoo <- zoo(accel.df[sample.start:sample.end,2:4],order.by=accel.df[sample.start:sample.end,1])
  plot(accel.zoo)
}

par(mfrow=c(1,3))
plot.seq(1,90)
plot.seq(91,151)
plot.seq(1,151)
par(mfrow=c(1,1))

x=accel.df[1:10,1]



#############################################################################################################
#############################################################################################################
# Cluster Plot against 1st 2 principal components
#clusplot(accel, fit$cluster, color=TRUE, shade=TRUE,labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
plotcluster(accel, fit$cluster,main="device") 
#Can we find sequences from the initial data?


# Ward Hierarchical Clustering
#if you get 'negative length vectors are not allowed', reduce number of rows
d <- dist(accel, method = "euclidean") # distance matrix
fit.h <- hclust(d, method="ward") 
plot(fit.h) # display dendogram
groups <- cutree(fit.h, k=cluster.count) # cut tree into clusters
# draw dendogram with red borders around the clusters 
rect.hclust(fit.h, k=cluster.count, border="red")



