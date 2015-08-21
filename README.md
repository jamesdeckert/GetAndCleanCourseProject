# GetAndCleanCourseProject
Course Project for Coursera Data Science #3 - Getting and Cleaning Data - Course Project

I begin by opening the test files (x, y, subject) and combining the columns
I do the same thing with the training files

I then combine the test and training files

I read in features.txt which contains field names and then name the columns of the combined test and training set

I then subset the dataframe but only finding column headers which contain mean() or std() and create a new dataframe with this data combined with the subject and activity columns.

I then just do several lines of testing that there are no missing values using a variety of methods

I read in the activity labels and merge them onto the combined dataframe using the activityID as the linking field

Then the dataframe is melted using the activityName (or I could have used the ID) and subjectID and my key value. The column names were pulled from my earlier subseting of only mean and std column names.
Then the dataframe was reformatted using dcast so each column would contain a std or mean.

This dataframe is then written to the hard drive.
