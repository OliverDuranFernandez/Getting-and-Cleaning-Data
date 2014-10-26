
library(reshape2)
#Reading Activity names
activity <- read.table(".\\UCI HAR Dataset\\activity_labels.txt", sep="", )
#reading feature names
featuresList <- read.table(".\\UCI HAR Dataset\\features.txt", sep="", )
#removing special characters
featuresList<-gsub("[[:punct:]]", "", featuresList[,2])

#reading train and test Datasets
trainDS <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt", sep="", col.names = featuresList)
testDS <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt", sep="", col.names = featuresList)

#select only the mean snd standard deviation columns
MeanStdColumns <-grepl("mean+|std+",names(trainDS))

#
SmalltrainDS <-trainDS[,MeanStdColumns]
SmalltestDS <-testDS[,MeanStdColumns]

#reading train and test subjects
trainSubjects<- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt", sep="")
testSubjects <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", sep="")
#add the subject columns to the datasets
SmalltrainDS$subject <- trainSubjects[,1]
SmalltestDS$subject <- testSubjects[,1]

#reading train and testactivity labels
trainLabels <- read.table(".\\UCI HAR Dataset\\train\\Y_train.txt", sep="")
testLabels <- read.table(".\\UCI HAR Dataset\\test\\Y_test.txt", sep="")
#merge the activity labels with the values to matching the names
x<-merge(trainLabels,activity, by.X = "v1", by.Y="v1")
y<-merge(testLabels,activity, by.X = "v1", by.Y="v1")
#Add the activity label to the datasets
SmalltrainDS$labels <- x[,2]
SmalltestDS$labels <- y[,2]

#create a dataset with the test and traing datasets
TidyDataset <- rbind(SmalltestDS,SmalltrainDS)

#creating a melted dataset
measurelist<-featuresList[MeanStdColumns]
FinalDataset <- melt(TidyDataset, id=c("subject","labels"), measure.vars=measurelist)

#getting the mean of the variables for each seubject and activity
new <- dcast(FinalDataset, subject + labels ~ variable, mean )

#writing the output file
write.table(new, file = "tidyDS.txt" ,  row.name=FALSE)
