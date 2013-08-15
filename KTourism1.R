#Initialize
rm(list=ls())

#Load library
library(forecast,lib.loc = "c:/work/R/Lib")

#Read data 
x=read.csv(file="tourism_data.csv",header=T)
data.example=read.csv(file="example.csv",header=T)

#Create list of timeseries
x.ts =list()
for(indx in 1:ncol(x)){
    x.ts[[indx]] =ts(na.omit(x[indx]))
}

#Pick a timeseries and plot prediction
par(mfrow=c(1,2))
ts0=x.ts[[51]]
plot(ts0)

fs0=forecast(ts0,h=4)
plot(fs0)
par(mfrow=c(1,1))

