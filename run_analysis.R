setwd("C:\\R\\Project")
library(dplyr);


file_locn <- file.path("./data" , "UCI HAR Dataset")

#load data frames

#activity files
actvty_train <- read.table(file.path(file_locn, "train", "Y_train.txt"),header = FALSE)
actvty_test  <- read.table(file.path(file_locn, "test" , "Y_test.txt" ),header = FALSE)
#subject files
subj_train <- read.table(file.path(file_locn, "train", "subject_train.txt"),header = FALSE)
subj_test  <- read.table(file.path(file_locn, "test" , "subject_test.txt"),header = FALSE)
#feature files
feat_train <- read.table(file.path(file_locn, "train", "X_train.txt"),header = FALSE)
feat_test  <- read.table(file.path(file_locn, "test" , "X_test.txt"),header = FALSE)


#merge vertically the datasets: test, train
dataSubject <- rbind(subj_train, subj_test)
dataActivity<- rbind(actvty_train, actvty_test)
dataFeatures<- rbind(feat_train, feat_test)


#assign name to the columns in the dataframefs
names(dataSubject)<-c("subject")
names(dataActivity)<-c("activity")
dataFeatureNames <- read.table(file.path(file_locn, "features.txt"),head=FALSE)
names(dataFeatures)<-dataFeatureNames$V2


#merge horizontally the datasets: subject, activity, features
allData1 <- cbind(dataSubject, dataActivity)
allData  <- cbind(allData1, dataFeatures)


#subset columns mean and std
subdataFeatureNames<-dataFeatureNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeatureNames$V2)]
selectedNames<-c(as.character(subdataFeatureNames), "subject", "activity" )
finalData <- subset(allData,  select=selectedNames)


#replace activity with name activity
activityLabels <- read.table(file.path(file_locn, "activity_labels.txt"),header = FALSE)
finalData$activity <- factor(finalData$activity, labels=activityLabels$V2)


#replace column names with appropriate values
names(finalData)<-gsub("^t", "time", names(finalData))
names(finalData)<-gsub("^f", "frequency", names(finalData))
names(finalData)<-gsub("Acc", "Accelerometer", names(finalData))
names(finalData)<-gsub("Gyro", "Gyroscope", names(finalData))
names(finalData)<-gsub("Mag", "Magnitude", names(finalData))
names(finalData)<-gsub("BodyBody", "Body", names(finalData))


#aggregate by subject and activity and average the variables
finalData2<-aggregate(. ~subject + activity, finalData, mean)
finalData2<-finalData2[order(finalData2$subject,finalData2$activity),]
write.table(finalData2, file = "tidydata.txt",row.name=FALSE)