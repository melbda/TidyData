run_analysis <- {
        
        ##Read tables of interest
        ##Provide column name of "subject" and "activity" for the subject and y_ files
        subjecttestdata <- read.table("C:/Users/corhol/Documents/data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
        subjecttraindata <- read.table("C:/Users/corhol/Documents/data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
        activitytestdata <- read.table("C:/Users/corhol/Documents/data/UCI HAR Dataset/test/y_test.txt", col.names = "activity")
        activitytraindata <- read.table("C:/Users/corhol/Documents/data/UCI HAR Dataset/train/y_train.txt", col.names = "activity")
        measurestestdata <- read.table("C:/Users/corhol/Documents/data/UCI HAR Dataset/test/x_test.txt")
        measurestraindata <- read.table("C:/Users/corhol/Documents/data/UCI HAR Dataset/train/x_train.txt")
        
        ##Read activity labels file with column names "activity" and "activitydesc"
        activitylabels <- read.table("C:/Users/corhol/Documents/data/UCI HAR Dataset/activity_labels.txt", col.names = c("activity","activitydesc"))
        
        ##Read features file to get measurement variable names
        features <- read.table("C:/Users/corhol/Documents/data/UCI HAR Dataset/features.txt")
        names(features) <- c("featureid","featuredesc")
        
        ##Add meaninful names to test and train data
        ##Get rid of V in the variable names so that we can join to the features table
        splittestnames <- strsplit(names(measurestestdata),"[a-zA-Z]")
        splittrainnames <- strsplit(names(measurestraindata),"[a-zA-Z]")
        
        secondElement <- function(x){x[2]}
        ##Takes the second element from each variable name out of the splits
        sapply(splittestnames, secondElement)
        
        names(measurestestdata) <- sapply(splittestnames, secondElement)
        names(measurestraindata) <- sapply(splittrainnames, secondElement)
        
        ##Combine the test tables into one test data table, do the same for the train data using cbind
        combinedtestdata <- cbind(subjecttestdata, activitytestdata, measurestestdata)
        combinedtraindata <- cbind(subjecttraindata, activitytraindata, measurestraindata)
        
        ##melt test and train data to pivot feature variable into one column
        testmelt <- melt(combinedtestdata,id=c("subject","activity"))
        trainmelt <- melt(combinedtraindata,id=c("subject","activity"))
        
        ##Rename "Variable" to featureid to prepare for join
        names(testmelt) <- c("subject","activity","featureid","measure")
        names(trainmelt) <- c("subject","activity","featureid","measure")
        
        ##Join on featureid to pull in featuredesc field
        testjoin <- join(testmelt, features, by="featureid")
        trainjoin <- join(trainmelt, features, by="featureid")
        
        ##Join on activity to pull in activity desc field
        testjoin2 <- join(testjoin, activitylabels, by="activity")
        trainjoin2 <- join(trainjoin, activitylabels, by="activity")
        
        ##select fields needed
        testfinal <- select(testjoin2, subject, activitydesc, featuredesc, measure)
        trainfinal <- select(trainjoin2, subject, activitydesc, featuredesc, measure)
        
        ##Subset where featuredesc like mean or std
        testmeanstd <- testfinal[grepl("mean",testfinal$featuredesc) | grepl("std",testfinal$featuredesc),]
        trainmeanstd <- trainfinal[grepl("mean",trainfinal$featuredesc) | grepl("std",trainfinal$featuredesc),]
        
        ##Combine test and train data together using rbind
        combineddata <- rbind(testmeanstd, trainmeanstd)
        
        ##Group by subject, activity, and featuredesc
        combineddatagrouped <- group_by(combineddata, subject, activitydesc, featuredesc)
        
        ##Summarize by average mean and standard deviation
        finaldata <- summarize(combineddatagrouped, mean = mean(measure))
        write.table(finaldata, file = "C:/Users/corhol/Documents/data/UCI HAR Dataset/tidydata.txt", row.name=FALSE)
}
