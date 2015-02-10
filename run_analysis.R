library(dplyr)

## make sure the folder exists
if (!file.exists("R_data")) { dir.create("R_data") }
## download the zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = ".\\R_data\\UCIHAR.zip", mode="wb")
## unzip the file
unzip(".\\R_data\\UCIHAR.zip", exdir = ".\\R_data")
## change the folder name came with the zip file
file.rename(".\\R_data\\UCI HAR Dataset\\", ".\\R_data\\UCIHAR\\")

## assign activity label to data frame activityLabel
activityLabel <- read.table(".\\R_data\\UCIHAR\\activity_labels.txt", sep = "", header = FALSE, col.names = c("ActivityID", "ActivityName"))
## assign feature to data frame feature
feature <- read.table(".\\R_data\\UCIHAR\\features.txt", sep = "", header = FALSE, col.names = c("FeatureID", "FeatureName"))

## train data

## assign subject to data frame trainSubject
trainSubject <- read.table(".\\R_data\\UCIHAR\\train\\subject_train.txt", sep = "", header = FALSE, col.names = c("SubjectID"))
## assign activity to data frame trainActivity
trainActivity <- read.table(".\\R_data\\UCIHAR\\train\\y_train.txt", sep = "", header = FALSE, col.names = c("ActivityID"))
## assign activity name to data frame trainActivityName
trainActivityName <- trainActivity
trainActivityName$ActivityName <- activityLabel[match(trainActivityName$ActivityID, activityLabel$ActivityID), "ActivityName"]
## assign train data to data frame trainData
trainData <- read.table(".\\R_data\\UCIHAR\\train\\x_train.txt", sep = "", header = FALSE, strip.white = TRUE, col.names = feature$FeatureName)

## test data

## assign subject to data frame testSubject
testSubject <- read.table(".\\R_data\\UCIHAR\\test\\subject_test.txt", sep = "", header = FALSE, col.names = c("SubjectID"))
## assign activity to data frame testActivity
testActivity <- read.table(".\\R_data\\UCIHAR\\test\\y_test.txt", sep = "", header = FALSE, col.names = c("ActivityID"))
## assign activity name to data frame testActivityName
testActivityName <- testActivity
testActivityName$ActivityName <- activityLabel[match(testActivityName$ActivityID, activityLabel$ActivityID), "ActivityName"]
## assign test data to data frame testData
testData <- read.table(".\\R_data\\UCIHAR\\test\\x_test.txt", sep = "", header = FALSE, strip.white = TRUE, col.names = feature$FeatureName)

## putting train data together, only getting mean and std column
trainDataCom <- cbind(typeData = c("train"), trainSubject, trainActivity, ActivityName=trainActivityName$ActivityName, trainData[,c(grep("*mean*|*std*", feature$FeatureName))])
## putting test data together, only getting mean and std column
testDataCom <- cbind(typeData = c("test"), testSubject, testActivity, ActivityName=testActivityName$ActivityName, testData[,c(grep("*mean*|*std*", feature$FeatureName))])

## putting the two data frames together
HARData <- rbind(trainDataCom, testDataCom)

## independent tidy data set with the average of each variable for each activity and each subject
## drop the two non-numeric columns, group by SubjectID and ActivityID, the rest of the fields take mean
HARDataAggr <- aggregate(HARData[, !(names(HARData) %in% c("typeData", "ActivityName"))], by = list(Group.SubjectID = HARData$SubjectID, Group.ActivityID = HARData$ActivityID), FUN = mean)

write.table(HARDataAggr, file=".\\R_data\\HARDataAggr.txt", sep = " ", row.names = FALSE)