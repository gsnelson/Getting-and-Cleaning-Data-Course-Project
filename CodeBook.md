## Getting and Cleaning Data Course Project Code Book

### Libraries / Functions
`data.table` - fread function <br>
`dplyr` - pull, select, arrange, group_by, summarize_all functions

### Inputs
The data used for this project is located on the UC Irvine Machine Learning Repository [web site](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The data files reside in a single zip file. *Note: As will be seen below, the data contained within the zip file is organized into test and train folders to facilitate machine learning techniques such as linear regression.*<br><br>
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

* Uses the fread function to load the data files into R objects. This step also performs parsing of the data into columns, stripping of whitespace, removing any blank rows and assigning temporary column names where needed.

## Transformations
Because of the way the data is structured (test vs. train, subject and activity data stored separately from the measurements), the majority of the transformation work deals with joining all of the related files together. The cbind and rbind functions were used to perform this action.<br><br>
The only modification to the data itself involved replacing the activity codes (i.e. 1, 2, 3...) with their descriptive equivalent (i.e. Walking, Standing, Walking Upstairs...) as required for the project.<br><br>
The project requirements stated that a subset containing only those variables measuring mean and standard deviation be created. For my script, this reduced the original 561 variables down to 66. Using a strict interpretation, I chose to exclude the 13 variables pertaining to Mean Frequency (meanfreq) as being outside the scope of the assignment requirements.<br><br>
I used `dplyr` functions to:
* `select` - create the subset
* `arrange` - sort the observations by subject (participant) and activity
* `group_by` - group the observations by subject and activity
* `summarize_all` - calculate the mean for each subject and activity<br><br>
The diagram below illustrates the transformation process
<img src="transformation diagram.png" width=800 height=800 align="center" title="Transformation Diagram" />

##### Variable Names
One of the project requirements is to appropriately label the data set with descriptive variable names.

Per Professor Leek's presentation, Editing Text Variables, variable names should:
- be all be lowercase when possible
- be non-duplicative
- not include underscores, periods or whitespace
- be descriptive<br>

*Implicit in the list is the requirement that variable names be syntactically correct (ability to be intrepreted by R without error)*

The variable names of the original dataset (561 variables) and the mean/standard deviation-only subset (66 variables) are complex due to the fact they represent several dimensional measurements (time vs. frequency, accelerometer vs. gyroscope, X, Y & Z axes) and calculations (mean, coefficent, standard deviation, etc.). I chose to leave the names themselves untouched under the assumption that they have to be meaningful to consumer of the output the run_analysis.R script produces. I, therefore, focused on making the structure of the variable names tidy.<br><br>
I started by converting all of the variable names to lower case and removing illegal characters '(', ')' and '-' (not syntactically correct). I then began the work to remove the periods but realized doing so would make the names difficult to understand. `tbodyacc.mean.x` would become `tbodyaccmeanx`.<br><br>
I consulted the Comprehensive R Archive Network (CRAN) FAQ [page](https://cran.r-project.org/doc/FAQ/R-FAQ.html#What-are-valid-names_003f) and the tidyverse style guide [page](https://style.tidyverse.org/syntax.html) and learned that underscores are acceptable in variable names. The CRAN site included periods as being acceptable too but I chose to use the underscore as being more ledgible. `tbodyacc.mean.x` would become `tbodyacc_mean_x`.

## Output
The script writes the data stored in the summarized_data object to a txt file. The txt is saved to the `.data` folder of the project folder.
