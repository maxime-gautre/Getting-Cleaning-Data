#
# This file does the following : 
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement. 
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive variable names. 
# - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
#

# Libraries required
require("data.table")
require("reshape2")


# Function which merge the training and the test sets
# 
# First, we read the file "activity_labels.txt" to get the class labels with their activity name.
# We read the file "features.txt" to get all features, then we extract the measurements on the mean and standard deviation.
# We rename columns name with appropriately labels.
# We call the function "extractData" twice, which build the entire test and training data sets (subject + activities + measurement).
# Finally, we merge them by calling the rbind method.
mergeData <- function(folder) {

	activityLabels <- readTable(folder, "/activity_labels.txt", filter = TRUE)
	features <- readTable(folder, "/features.txt", filter = TRUE)
	extractFeatures <- grepl("(mean\\(\\)|std\\(\\))", features)
	features <- gsub("-mean()","Mean",features,fixed=TRUE)
	features <- gsub("-std()","Std",features,fixed=TRUE)
	features <- gsub("BodyBody","Body",features,fixed=TRUE)

	testDataset <- extractData(activityLabels, features, folder, 'test', extractFeatures)
	trainDataset <- extractData(activityLabels, features, folder, 'train', extractFeatures)
	data <- rbind(trainDataset, testDataset)
	
	data
}	

# Function which extract data (subject, y: activities, x : measurement) of one particular dataType (train or set)
# We read files of the folder and dataType in argument
# We rename the columns
# We merge data with the cbind function
extractData <- function(activityLabels, features, folder, dataType, extractFeatures) {


	x <- readTable(folder, paste(dataType, "/X_", dataType, ".txt", sep=""))
	y <- readTable(folder, paste(dataType, "/Y_", dataType, ".txt", sep=""))
	subject <- readTable(folder, paste(dataType, "/subject_", dataType, ".txt", sep=""))

	names(x) <- features
	x <- x[, extractFeatures]
	names(subject) <- "Subject"
	labelY <- activityLabels[y[, 1]]
	y[, 2] <- labelY
	names(y) <- c("Id", "Label")
	
	cbind(as.data.table(subject), y, x)
}


# Function which calls the read.table method with the argument of the function (less verbose)
readTable <- function(folder, path, filter = FALSE) {

	if(filter) {
		read.table(paste("./", folder, "/", path, sep=""))[,2]
	} else {
		read.table(paste("./", folder, "/", path, sep=""))
	}
}

# Function which creates the tidy dataset. 
# First, we call the mergeData function to get the entire dataset (train + test) with only the measurements on the mean and standard deviation.
# We create the label and with melt the data.
# We call the dcast function to create the tidy data set with the average of each variable for each activity and each subject.
# Finally, we write this tidy data set in a file. 
createTidyData <- function(folder = "UCI HAR Dataset") {

	data <- mergeData(folder)
	labels = c("Subject", "Id", "Label")
	dataLabels = setdiff(colnames(data), labels)
	meltData = melt(data, id = labels, measure.vars = dataLabels)
	tidyData = dcast(meltData, Subject + Id + Label ~ variable, mean)

	write.table(tidyData, file = "./tidy-data.txt", sep="\t", row.names=FALSE)
}



