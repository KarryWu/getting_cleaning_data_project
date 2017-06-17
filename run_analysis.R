setwd("~/Desktop/R programming working directory/UCI HAR Dataset")

library(plyr)
library(dplyr)
library(reshape2)
library(knitr)

#1.Merge the training and the test data

#read the data
activityLabels <- read.table("./activity_labels.txt",header = FALSE)
features <- read.table("./features.txt",header = FALSE)
xTrain <- read.table("./train/X_train.txt",header = FALSE)
yTrain <- read.table("./train/Y_train.txt",header = FALSE)
subjectTrain <- read.table("./train/subject_train.txt",header = FALSE)
xTest <- read.table("./test/X_test.txt",header = FALSE)
yTest <- read.table("./test/Y_test.txt",header = FALSE)
subectTest <- read.table("./test/subject_test.txt",header = FALSE)

#add columns name
colnames(activityLabels) <- c("activityID","activityType")
colnames(features) <- c("featuresID","featuresName")
colnames(subectTest) <- "subjectID"
colnames(subjectTrain) <- "subjectID"
colnames(xTest) <- features[,2]
colnames(xTrain) <- features[,2]
colnames(yTest) <- "activityID"
colnames(yTrain) <- "activityID"

#merge the training data
training_data <- cbind(xTrain,yTrain,subjectTrain)

#merge the test data
test_data <- cbind(xTest,yTest,subectTest)

#merge the whole data
wholedata <- rbind(training_data,test_data)

#2.Extract only the measurements on the mean and standard deviation for each measurement
extractedData <- wholedata[,grepl("mean\\(\\)|std\\(\\)|activityID|subjectID",colnames(wholedata))]

#3.Uses descriptive activity names to name the activities in the data set
#join two dataframe
newData <- join(extractedData,activityLabels,by = "activityID")

#delete the column of activity ID
newData <- newData[,-(ncol(newData)-2)]

#4.Appropriately labels the data set with descriptive variable names

names(newData)<-gsub("^t", "time", names(newData))
names(newData)<-gsub("^f", "frequency", names(newData))
names(newData)<-gsub("Acc", "Accelerometer", names(newData))
names(newData)<-gsub("Gyro", "Gyroscope", names(newData))
names(newData)<-gsub("Mag", "Magnitude", names(newData))
names(newData)<-gsub("BodyBody", "Body", names(newData))

#5.Find the mean for each combination of subject and label

#melting data
melteddata <- melt(newData, id=c("subjectID","activityType"))

#casting data
tidy <- dcast(melteddata, subjectID+activityType ~ variable, mean)

#creating file
write.table(tidy, file = "tidydata2.txt",row.name=FALSE)
write.table(newData, file = "tidydata1.txt",row.name=FALSE)


