---
title: "CodeBook"
author: "Mohamed Tleis"
date: "6/26/2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## subject_train 
  The data of subject_train.txt file.
  
## Y_train 
  The data of the Y_train.txt (Activity number)
  
## X_train 
  The data of the X_train.txt (all the measured 561 features)

## features 
 The features loaded from features.txt. Has two columns (id and value)

## X_train_No_Surrounding_whitespace 
  The X_train dataset without the whitespace at the beginning and the end of the data. This is to ensure the empty spaces are not recognized as independent features when we split the data.

## X_train_tidy 
  The X_train dataset separated into columns
  
## subject_test 
  The data from the subject_test.txt file (Volunteer id)

## Y_test 
  The activity number loaded from Y_test.txt file.
  
## X_test 
  All the measured features in the X_test.txt file.

## X_test_No_Surrounding_whitespace 
  The X_test data with trimmed whitespaces from the beginning and the end of each row.

## X_test_tidy 
  The X_test data spearated into columns.

## training 
  All the training data in one tidy dataset.

## testing 
  All the testing data in one tidy dataset.

## full_dataset 
  Training and testing data merged into one dataset. 
  
## std_data 
  All the columns (from the 561 features) corresponding to standard deviations of features
  
## mean_data 
  All the columns corresponding to the mean of features.
  
## volunteer_id 
  A vector holding the volunteer ids 

## activity 
  A vector holding all the Activity 
  
## mean_std 
  A dataset of all the mean and standard deviation measurements.

## activity_labels
  The activity labels loaded from file.

## id 
  A numeric vector to hold the volunteer ids in the second dataset

## activities
  A character vector holding the activities

## split_by_volunteer
  The mean and standard deviation dataset splitted per Volunteer id.

## features_matrix 
  a matrix holding the computation of the mean for each feature in the mean_std dataset. The number of rows is equal to the number of volunteers mutliplied by the number of activities. The number of columns is equal to the number of features in the 'mean_std' dataset.

## row.count
  a variable for the new rows to be added to the new dataset

##  df 
  A data frame per each volunteer

##  prefix 
  The autmatically added prefix to the beginnning of variable names

##  split_per_activity
  Data splitted per activity. For each volunteer id.
  
##  activity 
  A lable of the activity (characters) 
  
## act.df
  Data frame per activity per volunteer

## averages 
  A numeric vector to hold averages for each feature
  
## nfeatures
  Number of features that we need to compute their averages.

##  feature_averages
  A data frame of tidy dataset having the volunteer id, averages for all the mean and std features and activity labels.
