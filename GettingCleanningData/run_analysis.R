library(tidyr)

## I. merge training and test data

# 1. load training data (subject, X and Y files)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
X_train <- read.table("UCI HAR Dataset/train/x_train.txt")

# 2. load the '561' feature names (to be used as column headers) 
features <- read.table("UCI HAR Dataset/features.txt")
colnames(features) <- c("id", "value")

## 3. load testing data (subject, X and Y files
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
X_test <- read.table("UCI HAR Dataset/test/x_test.txt")

## 4. Aggreate training & testing data (i.e. all the columns into one dataset)
training <- cbind(subject_train, X_train, Y_train)
testing <- cbind(subject_test, X_test, Y_test)

## 5. Concatenate training and testing data
full_dataset <- rbind(training, testing)
colnames(full_dataset) <- c("Volunteer ID", as.character(features$value), "Activity")

## II. measurement on the Mean and StdDev of each measurement
#. Extract the standard deviations measurement
std_data <- full_dataset[ grep("std", colnames(full_dataset)) ]
#. Extract the mean measurement
mean_data <- full_dataset[ grep("mean", colnames(full_dataset)) ]
#. Extract the voluntter id column
volunteer_id <- full_dataset[grep("Volunteer ID", colnames(full_dataset))]
#. Extract the Activity column
activity <- full_dataset[grep("Activity", colnames(full_dataset))]

#. Aggregate the columns into one tidy dataset
mean_std <- cbind(volunteer_id, mean_data, std_data, activity)

## III. Use descriptive activity names to name the activities in the data set
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c("id", "value")
mean_std$Activity <- factor(mean_std$Activity, levels=c(1:6), labels = activity_labels$value)

## IV. A second independent tidy dataset with the average of each variable and each subject
#. initialize the second tidy dataset that would hold the average mean values of the features in mean_std dataset

mean_std$`Volunteer ID` <- as.factor(mean_std$`Volunteer ID`)

allData.melted <- melt(mean_std, id = c("Volunteer ID", "Activity"))
allData.mean <- dcast(allData.melted, `Volunteer ID` + Activity ~ variable, mean)

#. append 'Avg' to feature names
  names(allData.mean) <- sub("^t", "Avg_t", names(allData.mean))
  names(allData.mean) <- sub("^f", "Avg_f", names(allData.mean))
}
write.csv(allData.mean, "final_tidy_data.csv")
