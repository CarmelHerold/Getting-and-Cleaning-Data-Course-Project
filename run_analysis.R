setwd(file.path("C:","Users","carme","Coursera", "gettind_and_cleaning_data"))
getwd()
library(dplyr)


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="Dataset.zip")
unzip(zipfile="Dataset.zip",exdir="data")

x_train <- read.table("data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('data/UCI HAR Dataset/features.txt')

activity_labels  = read.table('data/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <- c('activityId','activityType')

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
all_in_one <- rbind(mrg_train, mrg_test)

colNames <- colnames(all_in_one)

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

mean_sd <- all_in_one[ , mean_and_std == TRUE]

activity_names <- merge(mean_sd, activity_labels,
                              by='activityId',
                              all.x=TRUE)

tidydataset <- aggregate(. ~subjectId + activityId, activity_names, mean)
tidydataset <- tidydataset[order(tidydataset$subjectId, tidydataset$activityId),]

write.table(tidydataset, "tidydataset.txt", row.name=FALSE)
