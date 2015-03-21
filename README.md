# Getting Cleaning Data

## Objective

You should create one R script called run_analysis.R that does the following. 

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Setup the project

1. Download the data source and put into a folder (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
2. Downolad the run_analysis.R file and put it on the parent folder of the previous folder.
3. Open R and set the working directory to the folder containing the run_analysis.R file
4. Run source("run_analysis.R")
5. Run createTidyData(). By default, it calls the function with the default folder "UCI HAR Dataset". Otherwise, you can call the function with a folder name. For instance, createTidyData("my_folder").
6. A file called tidy-data.txt is created.