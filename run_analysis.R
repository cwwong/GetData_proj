#This is the course project for getting and cleaning data
#load librabry
library(dplyr)
#read the training set
X_trn <- read.table("train/X_train.txt")
y_trn <- read.table("train/y_train.txt")
sjt_trn <- read.table("train/subject_train.txt")

#read the test set
X_tst <- read.table("test/X_test.txt")
y_tst <- read.table("test/y_test.txt")
sjt_tst <- read.table("test/subject_test.txt")

#read the feature
features <- read.table("features.txt")

#read the acitivity labels
act_lab <- read.table("activity_labels.txt") 

#find the index for the features which are mean or std

meanidx <- grep("mean()",features$V2)
stdidx <- grep("std()",features$V2)
idx <- sort(c(meanidx,stdidx))

#subset the training and test set 
X_trn <- X_trn[,idx]
X_tst <- X_tst[,idx]
features <- features[idx,]

#merge the training and test set
X <- rbind(X_trn,X_tst)
names(X) <- features$V2

y <- rbind(y_trn,y_tst)
y <- as.data.frame(act_lab[y[,1],2])
names(y) <- "activity label"

sjt <- rbind(sjt_trn,sjt_tst)
names(sjt) <- "subject"

#combine the data into a single data frame
data <- cbind(sjt,y,X)

#sort the data per subject
data <- arrange(data,subject)
write.table(data,file = "data.txt", row.name=FALSE)

#creat another data which contains the average of each variables

datasummary <- data[,1:2]

for (i in 3:81){
tmp <- as.data.frame(ave(data[,i],data[,1],data[,2])) 
names(tmp) <- features$V2[i-2]
datasummary <- cbind(datasummary,tmp)
}

datasummary <- datasummary[!duplicated(datasummary ),]
write.table(datasummary ,file = "datasummary.txt", row.name=FALSE)




 

 
 