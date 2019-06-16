setwd("~/Alán/Otros Proyectos/Data Science Specialization/Regression Models/Course_Project")

#Downloading and reading data

download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv","./pml-training.csv")
download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv", "./pml-testing.csv")

training <- read.csv("pml-training.csv")
testing <- read.csv("pml-testing.csv")


na.cols <- colnames(training)[colSums(is.na(training)) > 0]
training <- training[,-which(colnames(training) %in% na.cols)]

blank.cols <- colnames(training)[colSums(training == "") > 0]
training <- training[,-which(colnames(training) %in% blank.cols)]
training <- training[,-c(1:7)]
tr.cols <- ncol(training)
colnames(testing)[160] <- c("classe")
testing <- testing[,colnames(training)]

library(caret)
set.seed(123)
model.rf <- train(classe ~ ., data = training, method = "rf",
                  trControl = trainControl(method = "cv", number = 10, verboseIter = TRUE))


model.rf
model.rf$finalModel
plot(model.rf$finalModel)

predictions.rf <- predict(model.rf, testing)

pred.df <- as.data.frame(testing$classe, predictions.rf)
