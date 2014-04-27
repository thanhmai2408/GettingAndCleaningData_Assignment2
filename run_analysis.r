#Extract training and testing data
X_Train_data <- read.table("train/X_train.txt")
Y_Train_data <- read.table("train/y_train.txt")

X_Test_data <- read.table("test/X_test.txt")
Y_Test_data <- read.table("test/y_test.txt")

subject_train <- read.table("train/subject_train.txt")
subject_test  <- read.table("test/subject_test.txt") 

#1. Merges the training and the test sets to create one data set.
X_combined <- rbind(X_Train_data, X_Test_data)
Y_combined <- rbind(Y_Train_data,Y_Test_data)
subject_combined <- rbind(subject_train,subject_test)

#Name features
features <- read.table("features.txt")
names(X_combined) <- features$V2

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
X_combined <- X_combined[,grep(".*mean\\(\\)|.*std\\(\\)", names(X_combined))]

#3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt")
Y_combined$V1[which(Y_combined$V1==1)] <- "WALKING"
Y_combined$V1[which(Y_combined$V1==2)] <- "WALKING_UPSTAIRS"
Y_combined$V1[which(Y_combined$V1==3)] <- "WALKING_DOWNSTAIRS"
Y_combined$V1[which(Y_combined$V1==4)] <- "SITTING"
Y_combined$V1[which(Y_combined$V1==5)] <- "STANDING"
Y_combined$V1[which(Y_combined$V1==6)] <- "LAYING"

#4. Appropriately labels the data set with descriptive activity names. 

names(Y_combined) <- "Activity"
names(subject_combined) <- "Subject"
combined <- cbind(subject_combined,Y_combined,X_combined)

#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
numSubjects <- 30 
numActivities <- 6
tidy_dataset <- data.frame(matrix(data=NA,nrow=numSubjects*numActivities,ncol=ncol(combined)))
names(tidy_dataset) <- names(combined)
index <- 0 
for (subject in 1:numSubjects) {
	for (activity in 1:numActivities) {
		index = index+1
		tidy_dataset[index, 1] = subject
		tidy_dataset[index, 2] = activity_labels[activity,2]
		tmp <- combined[which(combined$Subject== subject & combined$Activity==activity_labels[activity, 2]),3:ncol(combined)]
		tidy_dataset[index,3:ncol(combined)] <- apply(tmp,2,mean)		
	}
}

tidy_dataset$Activity[which(tidy_dataset$Activity==1)] <- "WALKING"
tidy_dataset$Activity[which(tidy_dataset$Activity==2)] <- "WALKING_UPSTAIRS"
tidy_dataset$Activity[which(tidy_dataset$Activity==3)] <- "WALKING_DOWNSTAIRS"
tidy_dataset$Activity[which(tidy_dataset$Activity==4)] <- "SITTING"
tidy_dataset$Activity[which(tidy_dataset$Activity==5)] <- "STANDING"
tidy_dataset$Activity[which(tidy_dataset$Activity==6)] <- "LAYING"

write.csv(tidy_dataset, "tidy_data_set.csv")