## Getting and Cleaning Data Course Project Code Book

### Libraries / Functions
`data.table` - fread function <br>
`dplyr` - pull, select, arrange, group_by, summarize_all functions

### Inputs
The data used for this project is located on the UC Irvine Machine Learning Repository [web site](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The data files reside in a single zip file. *Note: As will be seen below, the data contained within the zip file is organized into test and train folders to facilitate machine learning techniques such as linear regression.*
My run_analysis.R script performs the following import actions:
* Verifies that a `.data` folder exists in the project folder. If not, one is created.
* Downloads the zip file from the UC Irvine site to the `.data` folder
* Unzips the zip file contents to the `.data/UCI HAR Dataset` folder
* Deletes the zip file from the `.data` folder
* Creates objects to store the paths and filenames for the files needed for the project:

| Object                | Location                                          | Description                                           |
|:----------------------|:--------------------------------------------------|:------------------------------------------------------|
| `test_X_loc`          | *(.data/UCI HAR Dataset/test/X_test.txt)*         | smartphone measurements (actual or extrapolated)      |
| `test_y_loc`          | *(.data/UCI HAR Dataset/test/y_test.txt)*         | activity codes (i.e. 1 = walking) for the X data      |
| `test_subject_loc`    | *(.data/UCI HAR Dataset/test/subject_test.txt)*   | subject (participant) ID's associated with the X data |
| `train_X_loc`         | *(.data/UCI HAR Dataset/train/X_train.txt)*       | smartphone measurements (actual or extrapolated)      |
| `train_y_loc`         | *(.data/UCI HAR Dataset/train/y_train.txt)*       | activity codes (i.e. 1 = walking) for the X data      |
| `train_subject_loc`   | *(.data/UCI HAR Dataset/train/subject_train.txt)* | subject (participant) ID's associated with the X data |
| `col_names_loc`       | *(.data/UCI HAR Dataset/features.txt)*            | column headings for the X test and train measurements |
| `activity_labels_loc` | *(.data/UCI HAR Dataset/activity_labels.txt)*     | descriptions for the y test and train data            |

![transformation]("transform.jpg")

##### **Dataset Variables and Variable Names**
The source project dataset contains 561 variables/measurements that are multi-
dimensional in nature. The subset required for the assignment captures only
those 66 variables that measure mean and standard deviation. Using a strict
interpretation, I've chosen to exclude the 13 variables pertaining to Mean
Frequency (meanfreq) as being outside the scope of the assignment requirements.

At a high level, the subsetted variables are classified by:
* ***Domain:*** Time (t) or Frequency (f)
* ***Instrument:*** Accelerometer (acc) or Gyroscope (gyro)
* ***Linear Axis Signal Measurements:***
	* X: left (+)/right (-)
	* Y: forward (+)/backward (-)
	* Z: up (+)/down (-)
* ***Measures of Magnitude***

Per the presentation, Editing Text Variables, variable names should:
- be all be lowercase when possible
- be non-duplicative
- not include underscores, periods or whitespace
- be descriptive
