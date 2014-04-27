##Data Description
The data is downloaded from here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

##Transformation work
1. Import features matrix, subject, and activity files
2. Perform combination by rbind() command.
3. Use regular expression to extract only the mean data and std data
4. Run two for loop in term of subject and activity to get the average for all the measurements 
