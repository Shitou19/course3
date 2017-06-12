# read the train and test files
TrainTableX<-read.table("train\\X_train.txt")
TrainTableY<-read.table("train\\y_train.txt")
TrainSubject<-read.table("train\\subject_train.txt")
TestTableX<-read.table("test\\X_test.txt")
TestTableY<-read.table("test\\y_test.txt")
TestSubject<-read.table("test\\subject_test.txt")

# combine the files to joint_table (Merges the training and the test sets to create one data set.)
Train<-cbind(TrainTableX, TrainTableY, TrainSubject)
Test<-cbind(TestTableX, TestTableY, TestSubject)
Table<-rbind(Train, Test)

# add labels to the columns of the data set
namescolu<-read.table("features.txt")
colnames(Table)<-namescolu[,2]
colnames(Table)[562]<-"Activity"
colnames(Table)[563]<-"Subject"

# extract only the measurements on the mean and standard deviation for each measurement
col<-grep("mean|std", namescolu[,2], ignore.case = TRUE)
col<-c(col,562, 563)
JointDataSet<-Table[,col]

# use descriptive activity names to name the activities in the data set
JointDataSet[,'Activity']<-gsub("1", "WALKING", JointDataSet[,'Activity'])
JointDataSet[,'Activity']<-gsub("2", "WALKING_UPSTAIRS", JointDataSet[,'Activity'])
JointDataSet[,'Activity']<-gsub("3", "WALKING_DOWNSTAIRS", JointDataSet[,'Activity'])
JointDataSet[,'Activity']<-gsub("4", "SITTING", JointDataSet[,'Activity'])
JointDataSet[,'Activity']<-gsub("5", "STANDING", JointDataSet[,'Activity'])
JointDataSet[,'Activity']<-gsub("6", "LAYING", JointDataSet[,'Activity'])

# create a second tidy data set with the average of each variable for each activity and each subject
# and save it as a txt file
library(dplyr)
FinalDataSet<- JointDataSet %>% group_by(Subject, Activity) %>%  summarize_each(funs(mean))
write.table(FinalDataSet, file = "FinalDataSet.txt", row.names = FALSE)