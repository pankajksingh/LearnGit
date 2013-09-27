##Issue1: How to read contents from file(too big)
##Issue2: clustering fails on large number of rows- can we reduce rows? sequences? 
##net start mysql56

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


mySql.driver<-dbDriver("MySQL");
mySql.con<-dbConnect(mySql.driver,user='root',password='#bugsfor$',host='localhost',dbname='test');
result<-dbSendQuery(mySql.con, "select * from accel where device=7")
accel.df<- fetch(result, n = -1)


#pick subset of rows and ignore time/device dimension
cluster.count=3
accel <- accel.df[100:500,2:4]
fit <- kmeans(accel, cluster.count)
device.clust.sign <- c(length(fit$cluster[fit$cluster==1]),length(fit$cluster[fit$cluster==2]),length(fit$cluster[fit$cluster==3]))
device.clust.sign


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


#Find sign of sequences
#Few sequence ids={100006,100011,100012}
result.test<-dbSendQuery(mySql.con, "select * from acceltest where sequenceid=100012")
accel.df.test <- fetch(result.test, n = -1)

fit.test <- kmeans(accel.df.test, cluster.count)
seq.cluster <- fit.test$cluster;
sequence.clust.sign <- c(length(seq.cluster[seq.cluster==1]),length(seq.cluster[seq.cluster==2]),length(seq.cluster[seq.cluster==3]))
sequence.clust.sign
#TODO: Can we compare mean of 1(sequence) from mean of 1(device) ?

# Centroid Plot against 1st 2 discriminant functions
plotcluster(accel.df.test, seq.cluster,main="sequence") 




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


















#########################################################
x=read.csv(file="train.csv",header=T)
##data.example=read.csv(file="example.csv",header=T)

devic7=x[which(x[,5]==7),]

plot(devic7)


