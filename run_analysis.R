#get data and unzip
URLdata <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URLdata, destfile = "./dataset.zip", method="curl")
unzip(zipfile="./dataset.zip")


#get libraries
install.packages("data.table")
install.packages("dplyr")
library(data.table)
library(dplyr)

#read metadata
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

#1. Merges the training and the test sets to create one data set.
#Read Train data
TrainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
TrainActivity <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
TrainFeatures <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

#Read Test data
TestSubject <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
TestActivity <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
TestFeatures <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

#merge both Test and Training data
subject <- rbind(TrainSubject, TestSubject)
activity <- rbind(TrainActivity, TestActivity)
features <- rbind(TrainFeatures, TestFeatures)

colnames(features) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
mergedData <- cbind(features,activity,subject)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
ExtractMeanStd <- grep(".*Mean.*|.*Std.*", names(mergedData), ignore.case=TRUE)
ColumnsRequired <- c(ExtractMeanStd, 562, 563)

#find dimension of MergedData
dim(mergedData)


ExtractData <- mergedData[,ColumnsRequired]

#find dimention of ExtractData
dim(ExtractData)

#3. Uses descriptive activity names to name the activities in the data set
ExtractData$Activity <- as.character(ExtractData$Activity)
for (i in 1:6){
      ExtractData$Activity[ExtractData$Activity == i] <- as.character(activityLabels[i,2])
}

#4. Appropriately labels the data set with descriptive variable names. 

names(ExtractData)<-gsub("Acc", "Accelerometer", names(ExtractData))
names(ExtractData)<-gsub("Gyro", "Gyroscope", names(ExtractData))
names(ExtractData)<-gsub("BodyBody", "Body", names(ExtractData))
names(ExtractData)<-gsub("Mag", "Magnitude", names(ExtractData))
names(ExtractData)<-gsub("^t", "Time", names(ExtractData))
names(ExtractData)<-gsub("^f", "Frequency", names(ExtractData))
names(ExtractData)<-gsub("tBody", "TimeBody", names(ExtractData))
names(ExtractData)<-gsub("-mean()", "Mean", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("-std()", "STD", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("-freq()", "Frequency", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("angle", "Angle", names(ExtractData))
names(ExtractData)<-gsub("gravity", "Gravity", names(ExtractData))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
ExtractData$Subject <- as.factor(ExtractData$Subject)
ExtractData <- data.table(ExtractData)

tidyData <- aggregate(. ~Subject + Activity, ExtractData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)

