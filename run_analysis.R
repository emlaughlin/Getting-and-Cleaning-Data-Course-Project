##This section downloads, unzips, and reads the data
library(downloader)
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
         dest="dataset.zip", mode="wb")
unzip("dataset.zip")

##read subject data and change column name
traindata <- read.table("train/subject_train.txt", header = FALSE)
names(traindata)[names(traindata) == "V1"] <- "subject"

##read X_train data and name columns by features
x_train <- read.table("train/X_train.txt", header=FALSE)
features <- read.table("features.txt", header = FALSE, stringsAsFactors = FALSE)
colnames(x_train) <- features

##append X_train data to subject data
traindata <- cbind(traindata, x_train)

##read y_train data, replace data with activity labels
y_train <- read.table("train/y_train.txt", header = FALSE)
activities <- read.table("activity_labels.txt", header = FALSE)
activities <- activities$V2
y_train[y_train == 1] <- "WALKING"
y_train[y_train == 2] <- "WALKING_UPSTAIRS"
y_train[y_train == 3] <- "WALKING_DOWNSTAIRS"
y_train[y_train == 4] <- "SITTING"
y_train[y_train == 5] <- "STANDING"
y_train[y_train == 6] <- "LAYING"
names(y_train)[names(y_train) == "V1"] <- "activity"

##append y_train data to subject data
traindata <- cbind(traindata, y_train)

##repeat all steps for test data
testdata <- read.table("test/subject_test.txt", header = FALSE)
names(testdata)[names(testdata) == "V1"] <- "subject"
x_test <- read.table("test/X_test.txt", header=FALSE)
features <- read.table("features.txt", header = FALSE, stringsAsFactors = FALSE)
features <- features$V2
colnames(x_test) <- features
testdata <- cbind(testdata, x_test)
y_test <- read.table("test/y_test.txt", header = FALSE)
y_test[y_test == 1] <- "WALKING"
y_test[y_test == 2] <- "WALKING_UPSTAIRS"
y_test[y_test == 3] <- "WALKING_DOWNSTAIRS"
y_test[y_test == 4] <- "SITTING"
y_test[y_test == 5] <- "STANDING"
y_test[y_test == 6] <- "LAYING"
names(y_test)[names(y_test) == "V1"] <- "activity"
testdata <- cbind(testdata, y_test)

##Merging traindata and testdata
datasetFull <- rbind(traindata, testdata)

##extracting mean and std measurements
subfeatures <- features[grep("mean\\(\\)|std\\(\\)", features)]
selectedCols <- c("subject", "activity", as.character(subfeatures))
datasetFiltered <- subset(datasetFull, select = selectedCols)

##renaming variable labels to be more descriptive
names(datasetFiltered) <- gsub("^t", "time", names(datasetFiltered)) #t replaced by time
names(datasetFiltered) <- gsub("^f", "frequency", names(datasetFiltered)) #f replaced by frequency
names(datasetFiltered) <- gsub("Acc", "Accelerometer", names(datasetFiltered)) #Acc replaced by Accelerometer
names(datasetFiltered) <- gsub("Gyro", "Gyroscope", names(datasetFiltered)) #Gyro replaced by Gyroscope
names(datasetFiltered) <- gsub("Mag", "Magnitude", names(datasetFiltered)) #Mag replaced by Magnitude
names(datasetFiltered) <- gsub("BodyBody", "Body", names(datasetFiltered)) #BodyBody replaced by Body

##creating a second tidy data set with the avg of each variable 
##for each activity and each subject
library(plyr)
datasetAgg <- aggregate(. ~subject + activity, datasetFiltered, mean)
datasetAgg <- datasetAgg[order(datasetAgg$subject, datasetAgg$activity), ]
write.table(datasetAgg, file = "tidydata.txt", row.names = FALSE)

##create codebook
library(memisc)
Write(codebook(datasetAgg), file = "CodeBook.md")


