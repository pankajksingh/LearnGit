###################################################
### Part 0
### Initialize(tutorial & data links)
#http://cran.r-project.org/web/packages/e1071/vignettes/svmdoc.pdf
#http://archive.ics.uci.edu/ml/machine-learning-databases/glass/
###################################################
rm(list=ls())

###################################################
### Part 1
### Load Library add to depot
###################################################
library(e1071,lib.loc = "c:/work/R/Lib")
library(mlbench,lib.loc = "c:/work/R/Lib")

###################################################
### Part 2
### Load Data
###################################################
data(Glass, package="mlbench")

## split data into a training and test set
index <- 1:nrow(Glass)
testindex <- sample(index, trunc(length(index)/3))
testset <- Glass[testindex,]
trainset <- Glass[-testindex,]


###################################################
### Part 3
### Apply Model
###################################################
colnames(testset)
svm.model <- svm(Type ~ ., data = trainset, cost = 100, gamma = 1)
#column 10 is glass type
svm.pred <- predict(svm.model, testset[,-10])
plot(svm.pred)

#check model accuracy
dat.actual <- testset[,10]
dat.both <- cbind(svm.pred,dat.actual,dat.actual==svm.pred)
colnames(dat.both) <- c("prediction","actual","match")
accuracy <- 100*sum(dat.both[,"match"])/nrow(dat.both)
accuracy

#check model(confusion matrix)
table(pred = svm.pred, true = testset[,10])
