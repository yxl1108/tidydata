# tidydata
Repo for Getting and Cleaning Data Course Project

the run_analysis.R file does the following

1. import library dplyr, (it needs to be downloaded and installed first)
2. download the zip file and extract the zip file
3. getting the activity label and feature data into data frames
4. import into data frame with train data, while using the vector in feature data frame as the column names
5. do the same thing for test data.
6. cbind the train data (only the columns with mean or std in the names),  with subject and activity
7. do the same thing for test data
8. rbind the data frames generated in step 6 and 7
9. export the data frame generated in step 8
