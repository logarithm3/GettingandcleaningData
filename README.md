# GettingandcleaningData




The R script called run_analysis.R performs the following steps:
	1	Merges the training and the test sets to create one data set.
	2	Extracts only the measurements on the mean and standard deviation for each measurement. 
	3	Uses descriptive activity names to name the activities in the data set
	4	Appropriately labels the data set with descriptive variable names. 
	5	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Run source("run_analysis.R”):

1. It downloads the data source https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip , unzips the file and and puts the content into a folder on your local drive. A UCI HAR Dataset folder will be created for the content

2. It installs and reads the libraries : data.table and dplyr

3. It reads the metadata in UCI HAR Dataset

4. It reads the Test and Train data

5. Both data sets are merged

6. The mean and standard deviation are extracted

7. Dataset activity names are renamed

8. Tidy data file is created (tiny_data.txt) in your working directory

