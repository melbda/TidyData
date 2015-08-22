# TidyData
Course Project for the Coursera course Getting and Cleaning Data

Steps carried out in run_analysis.R
Tables of interest are read into data tables
Column names are provided where missing (examples "subject", "activity", "features", "featuresdesc")
The names in the test and train measure data table are split using strsplit and sapply to get rid of the first element (V), to enable a seamless join to the features table later (to pull in the features desc field)
Two combined data sets are created by column binding the raw data files, one for test and one for training
These two data sets are melted so that the features columns are pivoted into rows, making each observation a separate row (tidying).
Columns names are renamed to be more meaninful (variable renamed to "featureid")
Joins to the features table and activity table to pull in the activity description and feature description fields
Select funtion is used to filter on variables needed in meaninful order.
Data is subsetted using grepl function where featuredesc contains "mean" or "stddev"

Combined data set is created using rbind to combine train and test subjects into one data set.
The combined data set is grouped by subject, activity description, and feature description
The final data set is summarized by the grouped data to show the mean for each variable (featuredesc) for each activity and subject.
