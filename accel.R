library(zoo,lib.loc="c:/work/R/Lib")

x=read.csv(file="train.csv",header=T)
##data.example=read.csv(file="example.csv",header=T)

devic7=x[which(x[,5]==7),]

plot(devic7)


install.packages("RMySQL")
library(RMySQL)


##http://stackoverflow.com/questions/4785933/adding-rmysql-package-to-r-fails