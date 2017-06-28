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

## V. A second independent tidy dataset with the average of each variable and each subject
#. initialize the second tidy dataset that would hold the average mean values of the features in mean_std dataset

# 1. create a vector to hold the volunteer id
id <- vector('numeric')
# 2. Create a character vector to hold the activity name
activities <- vector('character')
# 3. Split the data per Volunteer ID
split_by_volunteer<-split(mean_std, as.factor(mean_std$`Volunteer ID`) )

# 4. Create a matrix to hold the computation of the mean for 
# each feature. The number of rows is equal to the number of volunteers
# mutliplied by the number of activities. The number of columns is equal
# to the number of features in the 'mean_std' dataset.
features_matrix <- matrix(, nrow = length(split_by_volunteer)* length(activity_labels$value), ncol = (length(mean_std)-2) )
# 5. Initialise a variable for the new rows to be added to the new dataset
row.count <- 1
# 6. loop through each volunteer
for(i in 1 : length(split_by_volunteer) ) {
  #. Create a data frame per each volunteer
  df <- as.data.frame(split_by_volunteer[i])
  #. Remove the autmatically added prefix to the beginnning of variable names
  prefix <- paste("X", i , "." , sep="")
  colnames(df)<-sub(prefix, "", colnames(df) )
  #. Split each data frame per activity
  split_per_activity<-split(df, as.factor(df$Activity) )
  #. loop through each activity
  for(j in levels(as.factor(df$Activity))) {
    #. obtain the activity as a label
    activity <- paste("", j , sep="")
    #. Obtain a datafraem per each activity for each volunteer
    act.df<-as.data.frame(split_per_activity[activity])
    #. Create a numeric vector to hold averages of all features
    averages <- vector('numeric')
    #. Loop through all columns in df 
    nfeatures<-ncol(act.df)-2
    for (x in 1:nfeatures) {
      averages[x] <- mean(as.numeric(as.character(act.df[,(x+1)] ) ))
    }
    #. Create an instance with id of volunteer and the activity
    # in addition to averages of all mean and std features
    id[row.count] <- i
    activities[row.count] <- j
    features_matrix[row.count,] <- averages
    row.count <- row.count+1
  }
  #. Combine the vectors into one data frame
  feature_averages<-as.data.frame(cbind(id, features_matrix, activities))
  #. Add the column names and append 'Avg' for the new feature column names
  colnames(feature_averages) <- colnames(mean_std)
  names(feature_averages) <- sub("^t", "Avg_t", names(feature_averages))
  names(feature_averages) <- sub("^f", "Avg_f", names(feature_averages))
}
write.csv(feature_averages, "final_tidy_data.csv")
