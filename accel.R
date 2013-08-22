#Initialize
rm(list=ls())


##Installing RMySQL from source. 
##install.packages("RMySQL",type='source',lib="c:/work/R/Lib")
library(RMySQL,lib.loc="c:/work/R/Lib")
#Rcmd.bat INSTALL RMySQL.whatever.tar.gz 
##http://stackoverflow.com/questions/4785933/adding-rmysql-package-to-r-fails

mySql.driver<-dbDriver("MySQL");
mySql.con<-dbConnect(mySql.driver,user='root',password='#bugsfor$',host='localhost',dbname='test');
result<-dbSendQuery(con, "select * from accel where device=7")
accel.df<- fetch(result, n = -1)




library(zoo,lib.loc="c:/work/R/Lib")

x=read.csv(file="train.csv",header=T)
##data.example=read.csv(file="example.csv",header=T)

devic7=x[which(x[,5]==7),]

plot(devic7)


