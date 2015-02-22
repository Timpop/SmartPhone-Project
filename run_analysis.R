#download main data and unzip at working Directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileUrl, destfile = "courseradata.zip", method = "auto") 
unzip("courseradata.zip")

#load and combine related dataset
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
xcomb <- rbind(xtrain, xtest)
ycomb <- rbind(ytrain, ytest)
scomb <- rbind(subtrain, subtest)

#load activities & features
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
colnames(activities)<-c("ActNum","ActDescri")
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(features)<-c("FeaNum","FeaDescri")
colnames(xcomb)<-features$FeaDescri
colnames(ycomb)<-"ActNum"
colnames(scomb)<-"Subject"

#merge with activity labels and y dataset
mergedatay<-merge(activities,ycomb,by.y="ActNum")

# combine all data
alldata <- cbind(xcomb,mergedatay)
alldata_mean<-sapply(alldata,mean,na.rm=TRUE)
alldata_sd<-sapply(alldata,sd,na.rm=TRUE)

#Creating the Tidy Data set with different order and alldataset

tidyDataSetMix <- aggregate(alldata[,1:561], by =list(alldata[,"ActNum"], alldata[,"ActDescri"]), FUN = mean, na.rm = TRUE)
tidyDataSetActNum <- aggregate(alldata[,1:561], by =list(alldata[,"ActNum"]), FUN = mean, na.rm = TRUE)
tidyDataSetActDescri <- aggregate(alldata[,1:561], by =list(alldata[,"ActDescri"]), FUN = mean, na.rm = TRUE)
write.csv(alldata,file="./UCI HAR Dataset/alldata.csv",row.names=FALSE,sep=",")
write.table(tidyDataSetMix,file="./UCI HAR Dataset/tidyDataSetMix.txt",row.names=FALSE,sep=",")
