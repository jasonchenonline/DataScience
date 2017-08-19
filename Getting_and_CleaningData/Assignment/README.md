Getting and Cleaning Data: Course Project
=========================================

Introduction
------------
This repository contains the course project for the Coursera course "Getting and Cleaning data", part of the Data Science specialization.


About the raw data
------------------

The features (561 of them) are unlabeled and can be found in the x_test.txt. 
The activity labels are in the y_test.txt file.
The test subjects are in the subject_test.txt file.

The same holds for the training set.

About the script and the tidy dataset
-------------------------------------
I created a script called run_analysis.R which will merge the test and training sets together.
Prerequisites for this script:

1. the UCI HAR Dataset must be availble in a directory called "Data_HAP"

Script will process the data set with following steps:

1. Extract data from data file to data tables.
2. Transformation of data. 
2.1 Filtering only measurements on the mean and standard deviation for each meansurement.
3. Join Activity to measurment, apply descriptive names to Activity
4. Apply descriptive labels to variables
5. Tidy data by create a independent tidy dataset with average of each variables.

About the Code Book
-------------------
The CodeBook.md file explains the transformations performed and the resulting data and variables.