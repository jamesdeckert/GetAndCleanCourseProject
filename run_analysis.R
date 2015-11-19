#must have utility package imported
#library(plyr)
library(data.table)
library(reshape2)
#library(utility)
#library(dplyr)

# read in x test files and append Activity and Subject files
xTbl=read.table("./X_test.txt", head=FALSE) 
yTbl=read.table("./y_test.txt", head=FALSE) 
subjTbl=read.table("./subject_test.txt", head=FALSE) 
CombTest=cbind(xTbl,yTbl,subjTbl)

# read in x training files and append Activity and Subject files
xTbl=read.table("./X_train.txt", head=FALSE) 
yTbl=read.table("./y_train.txt", head=FALSE) 
subjTbl=read.table("./subject_train.txt", head=FALSE) 
CombTrain=cbind(xTbl,yTbl,subjTbl)

# combine test and training data
CombAll=rbind(CombTest, CombTrain)

# add column names
ColHeaders=read.table("./features.txt", head=FALSE) 
x<-as.vector(ColHeaders[,2])
x<-append(x, c("ActivityID", "SubjectID"))
colnames(CombAll)<-x # grab only the column headers from second column and append to dataframe

#Subset the data frame into pieces looking for mean and std columns only
xMean<-CombAll[,grepl(glob2rx('*mean()*'), colnames(CombAll))]
xStd<-CombAll[,grepl(glob2rx('*std()*'), colnames(CombAll))]

#Put mean and std only into data frame with activity and subject columns also
CombMeanStdAll<-cbind(xMean,xStd,ActivityID=CombAll$ActivityID,SubjectID=CombAll$SubjectID)
StatCols<-c(names(xMean),names(xStd))

#check for missing values in table
#several ways to do the same thing - just playing here
cat("missing values in table=")
sum(is.na(CombMeanStdAll))
any(is.na(CombMeanStdAll))
colSums(is.na(CombMeanStdAll))
all(colSums(is.na(CombMeanStdAll))!=0)

#merge the activity names (e.g. Walking, running, laying down) onto data frame
ActivityLabels=read.table("./activity_labels.txt", head=FALSE) 
colnames(ActivityLabels)<-c("ID","ActivityName")
CombMeanStdAll=merge(CombMeanStdAll, ActivityLabels, by.x="ActivityID", by.y="ID" )

meltedDF <- melt(CombMeanStdAll, id=c("ActivityName", "SubjectID"),  measure.vars = StatCols)  
tidyDS <-dcast(meltedDF, ActivityName + SubjectID ~  StatCols, mean) # average each activity by subject
write.table(tidyDS, file="./tidyDataSet.txt",row.names=FALSE)
