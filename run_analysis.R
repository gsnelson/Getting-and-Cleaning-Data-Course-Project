## load required libraries
library(data.table)
# library(tidyselect)
library(dplyr)



## instantiate variables
fileURL <-
	"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_loc <- ".data/getdata_projectfiles_UCI HAR Dataset.zip"
test_X_loc <- ".data/UCI HAR Dataset/test/X_test.txt"
test_y_loc <- ".data/UCI HAR Dataset/test/y_test.txt"
test_subject_loc <- ".data/UCI HAR Dataset/test/subject_test.txt"
train_X_loc <- ".data/UCI HAR Dataset/train/X_train.txt"
train_y_loc <- ".data/UCI HAR Dataset/train/y_train.txt"
train_subject_loc <- ".data/UCI HAR Dataset/train/subject_train.txt"
col_names_loc <- ".data/UCI HAR Dataset/features.txt"
activity_labels_loc <- ".data/UCI HAR Dataset/activity_labels.txt"


## check for data folder / create if necessary
if (!file.exists("./data")) {
	dir.create(".data")
}


## download data zip file to data folder, unzip it and then delete zip file
download.file(fileURL, destfile = data_loc)
unzip(data_loc, exdir = ".data")
if (file.exists(data_loc))
	file.remove(data_loc)


## retrieve column names of the X test & train data files
col_names <- pull(
	fread(
		col_names_loc,
		sep = " ",
		header = FALSE,
		strip.white = TRUE,
		blank.lines.skip = TRUE,
		col.names = c("num", "label"),
	),
	label
)


## retrieve activity numbers & descriptions
activity_labels <-
	fread(
		activity_labels_loc,
		sep = " ",
		header = FALSE,
		strip.white = TRUE,
		blank.lines.skip = TRUE,
		col.names = c("num", "label")
	)


## read train data into the X & y & subject train_data dataframe objects
train_X_data <-
	fread(
		train_X_loc,
		sep = " ",
		header = FALSE,
		strip.white = TRUE,
		blank.lines.skip = TRUE,
		col.names = col_names
	)

train_y_data <-
	fread(
		train_y_loc,
		sep = " ",
		header = FALSE,
		strip.white = TRUE,
		blank.lines.skip = TRUE,
		col.names = "Activity"
	)

train_subject_data <-
	fread(
		train_subject_loc,
		sep = " ",
		header = FALSE,
		strip.white = TRUE,
		blank.lines.skip = TRUE,
		col.names = "Subject"
	)


## column bind the train dataframes together
train_data_all <-
	cbind(train_subject_data, train_y_data, train_X_data)


## read test data into the X & y & subject test_data dataframe objects
test_X_data <-
	fread(
		test_X_loc,
		sep = " ",
		header = FALSE,
		strip.white = TRUE,
		blank.lines.skip = TRUE,
		col.names = col_names
	)

test_y_data <-
	fread(
		test_y_loc,
		sep = " ",
		header = FALSE,
		strip.white = TRUE,
		blank.lines.skip = TRUE,
		col.names = "Activity"
	)

test_subject_data <-
	fread(
		test_subject_loc,
		sep = " ",
		header = FALSE,
		strip.white = TRUE,
		blank.lines.skip = TRUE,
		col.names = "Subject"
	)


## column bind the train dataframes together
test_data_all <- cbind(test_subject_data, test_y_data, test_X_data)


## row bind the train and test dataframes
data_all <- rbind(train_data_all, test_data_all)


## remove objects from memory that are no longer needed
rm(list = ls(pattern = "^t", all.names = TRUE))
rm(list = ls(pattern = "^X", all.names = TRUE))
rm("fileURL", "data_loc", "col_names_loc", "activity_labels_loc")

## replace numeric activity codes with descriptions from the activity_labels.txt
## file
data_all$Activity <-
	activity_labels$label[match(data_all$Activity, activity_labels$num)]


## transform the variable names
# remove duplicated variable names and replace characters that aren't
# interpreted by R ( () and - ) with periods
valid_variable_names <-
	make.names(c("subject", "activity", col_names), unique = TRUE)

# replace periods with underscores and set variable names to lower case
valid_variable_names <-
	gsub("\\.|\\.\\.|\\.\\.\\.", "_", tolower(valid_variable_names))
valid_variable_names <- gsub("_$", "", valid_variable_names)
# clean up some duplication in the variable names
valid_variable_names <-
	gsub("bodybody", "body", valid_variable_names)
names(data_all) <- valid_variable_names


## 1. subset the dataframe to include only those variables which calculate
## mean & standard deviation
## 2. sort by subject and activity
## 3. group by subject and activity
## 4. summarize by group / calculate mean
summarized_data <-
	select(data_all, c(
		"subject",
		"activity",
		!starts_with("an") & (
			contains("_std_") |
				contains("_mean_") |
				ends_with("std") |
				ends_with("mean")
		)
	)) %>% arrange(subject, activity) %>% group_by(subject, activity) %>%
	summarize_all(list(mean))


## write the summarized data to a text file
write.table(
	summarized_data,
	file = "./.data/GSN-tidydata.txt",
	row.names = FALSE,
	col.names = TRUE,
)


## remove objects from memory that are no longer needed
rm("valid_variable_names", "data_all", "col_names", "activity_labels", "summarized_data")
