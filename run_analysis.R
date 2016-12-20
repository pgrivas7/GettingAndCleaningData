#################################################################################
##
## Getting and Cleaning Data course project
##
## Pete Grivas
## 2016-12-18
##
#################################################################################
## Reset environment
rm(list=ls())

## Set local working directory
## COMMENTED ON 12/20/16 @ 10:36 AM EST AFTER REALIZING I HAD LEFT THIS IN...
## setwd("/Users/pgrivas/Personal/Active Documents/Education/Coursera/Johns Hopkins - Data Science/3. Getting and Cleaning Data/Course Project")

## Download the data to the working directory if there is not a copy already here
if (!file.exists("UCI HAR Dataset")) {
        sourceDataTypesURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(sourceDataTypesURL, destfile = "UCIHAR.zip", method = "curl")
        unzip("UCIHAR.zip")
}


## Create a helper function to help us locate the files in the right folders
ROOTDATAPATH <- "UCI HAR Dataset"

#################################################################################
## generateFilePath - takes two sets of arguements
##      1) dataFile, which is a data file in our root data directory
##      2) filenameTemplate and sourceDataTypesType, where we substitute the 
##              data type (train or test) in the filename and file path to
##              get the right file in the train/test subdirectories
#################################################################################
generateFilePath <- function(dataFile, filenameTemplate, sourceDataTypesType) {
        if (missing(filenameTemplate)) {
                filePath <- paste0(ROOTDATAPATH, "/", dataFile)
        }
        else {
                fileName <- sub("TYPE", sourceDataTypesType, filenameTemplate)
                filePath <- paste0(ROOTDATAPATH, "/", sourceDataTypesType, "/", fileName)
        }
        #print(filePath)
        return(filePath)
}


#################################################################################
## Part One - produce a complete list of measurementData
#################################################################################

## Load activity codes for merging with "y" dataset
activityTypes <- read.table(generateFilePath("activity_labels.txt"), header = FALSE)

## Loop through each of the two data sources
sourceDataTypes <- c("test", "train")

for (dataType in sourceDataTypes) {

        ## Get the subject (participant) identifier
        fileName <- generateFilePath(NULL, "subject_TYPE.txt", dataType)
        subjectIdentifiers <- read.csv(fileName, header = FALSE)
        
        ## Get the activity type identifier, and replace the ID with descriptive text in the data for our output
        fileName <- generateFilePath(NULL, "y_TYPE.txt", dataType)
        activities <- read.csv(fileName, header = FALSE)
        activities <- merge(activities, activityTypes, by.x = "V1", by.y = "V1")[2]
        
        ## Load all of the measurement data, provided in the "x" file
        fileName <- generateFilePath(NULL, "X_TYPE.txt", dataType)
        measurementData <- read.table(fileName, header = FALSE)
        
        ## If this is the first pass of the loop, create the initial allMeasurements data frame
        ## consisting of the:
        ## Column 1 - Data Source
        ## Column 2 - Subject Identifier
        ## Column 3 - Activity Type
        ## Columns 4+ - Sensor Data
        if (!exists("allMeasurements")) {
                allMeasurements <- data.frame(rep(dataType, nrow(measurementData)), subjectIdentifiers, activities, measurementData)
        }
        ## Otherwise, append the data from the second loop to the end of the existing data frame
        else {
                allMeasurements <- rbind(allMeasurements, data.frame(rep(dataType, nrow(measurementData)), subjectIdentifiers, activities, measurementData))
        }
}


## Create column names based on the labels in the features.txt file
dataColumnNames <- read.table(generateFilePath("features.txt"), header = FALSE)
names(allMeasurements) <- c("sourceType", "subjectId", "activityType", as.character(dataColumnNames[ ,2]))

## Keep the first few descriptive columns and also mean and std. deviation columns
##   and drop the remaining, unnecessary columns
keep <- c(1:3, grep("mean\\()", names(allMeasurements)), grep("std\\()", names(allMeasurements)))
allMeasurements <- allMeasurements[ , keep]
names(allMeasurements) <- sub("\\()", "", names(allMeasurements))



#################################################################################
## Part Two - produce a data file with a average for all output columns from part one
##              group by subject number and activity type
#################################################################################
## Create the averaged data
averagedMeasurementData <- aggregate(allMeasurements[, 4:ncol(allMeasurements)], list(allMeasurements$subjectId, allMeasurements$activityType), mean)

colnames(averagedMeasurementData)[3:ncol(averagedMeasurementData)] <- paste("Avg_", colnames(averagedMeasurementData[,3:ncol(averagedMeasurementData)]), sep = "")


## Rename the data frame columsn to be readable
names(averagedMeasurementData)[1:2] <- c("SubjectID", "ActivityType")

## Resort the data frame by subject and activity
averagedMeasurementData <- averagedMeasurementData[order(averagedMeasurementData$SubjectID, averagedMeasurementData$Activity), ]

## Write the averagedMeasurementData to disk
write.table(averagedMeasurementData, file = "averagedMeasurementData.txt", row.names = FALSE)

