### Getting and Cleaning Data Course Project
This project focuses on data collected during a study conducted by members of SmartLab, Genoa, Italy and Universitat Politècnica de Catalunya, Barcelona, Spain.<br><br>
Below is an abstract of the study and the resulting dataset taken from the UC Irvine Machine Learning Repository web site:<br><br>
*The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.*

*The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.*<br><br>
The study data, available on the UC Irvine repository site, is stored in a zip file and organized between test and train groups. The data files used for this project are:<br>
* `X_test.txt` and `X_train.txt` - contain the measurements collected directly from the smartphones, as well as the additional measurements extrapulated from that data
* `subject_test.txt` and `subject_train.txt` - contain the subject (participant) IDs represented as integer values. These files match row-for-row with the X_test and X_train files
* `y_test.txt` and `y_train.txt` - contain the activity IDs represented as integer values. These files match row-for-row with the X_test/subject_test and X_train/subject_train files
* `activity_labels.txt` - contains the character descriptions of the activities IDs (i.e. 1 = Walking) included in the y_test and y_train files
* `features.txt` - contains the variable (column) names for the measurements. These files match column-for-column with the X_test and X_train files<br><br>

The goal of this project is to transform the smartphone study data into a tidy dataset. Specifically, the requirements are:<br>
1. Merge the training and the test sets to create one data set
2. Extract only the measurements on the mean and standard deviation for each measurement
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names
5. Create a second, independent tidy data set with the average of each variable for each activity and each subject (as a text export file)<br><br>

The run_analysis.R script performs the following tasks (in order):
1. Download the zip file from the UC Irvine repository site to the project `.data` folder
2. Unzip the contents into the `.data/UCI HAR Dataset` folder
3. Delete the zip file
4. Read the data files listed above into R objects
5. Join the X, y and subject objects into one dataframe for both test and train
6. Join the test and train dataframes into one dataframe
7. Match and replace the numeric activity IDs with the descriptions in the activity_labels object
8. Replace the existing variable names with tidy/descriptive names
9. Subset the consolidated dataframe so that only variables measuring mean and standard deviation remain
10. Sort the subset by subject (participant) and activity
11. Group the subset by subject (participant) and activity
12. Summarize the subset observations by calculating the mean for each subject and each activity
13. Write the results to a csv file and save it to the `.data` folder
