##net start mysql56

#Initialize
rm(list=ls())

library(zoo,lib.loc="c:/work/R/Lib")
##Installing RMySQL from source. 
##install.packages("RMySQL",type='source',lib="c:/work/R/Lib")
library(DBI,lib.loc="c:/work/R/Lib")
library(RMySQL,lib.loc="c:/work/R/Lib")
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
accel <- accel.df[100:200,2:4]
fit <- kmeans(accel, cluster.count)

# Cluster Plot against 1st 2 principal components
clusplot(accel, fit$cluster, color=TRUE, shade=TRUE,labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
plotcluster(accel, fit$cluster) 

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


