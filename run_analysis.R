## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5.From the data set in step 4, creates a second, independent tidy data set with the 
##   average of each variable for each activity and each subject.

getwd()
setwd("C:/Users/Steve/Desktop/Coursera/Getting and Cleaning Data/Project/run_analysis")

## Get Data for the problem
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

## Unzip the data into the .data folder for use in the project
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## verify that the files are in the .data folder
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
# files

if (!require("data.table")) {               # check to see if 'data.table' is installed
    install.packages("data.table")          # if not installed, Install 'data.table'
}                                           # data.table inherits from data.frame. It offers 
                                            # fast subset, fast grouping, fast update, fast ordered 
                                            # joins and list columns in a short and flexible syntax,
                                            # for faster development. 

if (!require("reshape2")) {                 # check to see if 'reshape2' is installed
    install.packages("reshape2")            # if not installed, Install 'reshape2'
}                                           # 'reshape2' transforms data between wide and long formats
                                                # Wide data has a column for each variable.
                                                #       ozone   wind    temp
                                                # 1     23.62   11.623  65.55
                                                #
                                                # And this is long-format data:
                                                #       variable  value
                                                # 1     ozone     23.615
                                                # 2     wind      11.623
                                                # 3     temp      79.100

require("data.table")
require("reshape2")

# Load: activity labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")[,2]
# Data:
# 1 WALKING 2 WALKING_UPSTAIRS 3 WALKING_DOWNSTAIRS 4 SITTING 5 STANDING 6 LAYING


# Load: data column names
features <- read.table("./data/UCI HAR Dataset/features.txt")[,2]
# Data:
# [1] tBodyAcc-mean()-X                    tBodyAcc-mean()-Y                    tBodyAcc-mean()-Z                   
# [4] tBodyAcc-std()-X                     tBodyAcc-std()-Y                     tBodyAcc-std()-Z                    
# [7] tBodyAcc-mad()-X                     tBodyAcc-mad()-Y    ...


# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features_mean_std <- grepl("mean|std", features)
# Result: (true indicates it is mean or standard deviation; false indicates it is another measure)
#   [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#   [21] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE


# Load and process X_test & y_test data.
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
# Data:
# 2.5717778e-001 -2.3285230e-002 -1.4653762e-002 -9.3840400e-001 -9.2009078e-001 
# -6.6768331e-001 -9.5250112e-001 -9.2524867e-001 ...

y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
# Data: 
# 5
# 5
# 5
# ...

subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
# Data: 
# 2
# 2
# 2
# ...

# ?names
names(X_test) = features # set names for x_test to 'features'
                         # features contains the calculation from the 'features.txt' file

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_features_mean_std]  # remember 'extract_features_mean_std' contains true for stdev and mean vaalues

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]           # assign activity labels (standing, sitting, laying, etc)
names(y_test) = c("Activity_ID", "Activity_Label") # set column names
names(subject_test) = "subject"                    # set subject test to "subject"

# Bind the data
# ?cbind
# ?as.data.table
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
# sample test_data output from row 1:
#   subject Activity_ID   Activity_Label tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X
#1:       2           5         STANDING         0.2571778       -0.02328523       -0.01465376       -0.9384040

#     tBodyAcc-std()-Y tBodyAcc-std()-Z tGravityAcc-mean()-X tGravityAcc-mean()-Y tGravityAcc-mean()-Z tGravityAcc-std()-X
#  1:      -0.92009078       -0.6676833            0.9364893           -0.2827192            0.1152882          -0.9254273

#   tGravityAcc-std()-Y tGravityAcc-std()-Z tBodyAccJerk-mean()-X tBodyAccJerk-mean()-Y tBodyAccJerk-mean()-Z
#1:          -0.9370141          -0.5642884            0.07204601           0.045754401          -0.106042660

#       tBodyAccJerk-std()-X tBodyAccJerk-std()-Y tBodyAccJerk-std()-Z tBodyGyro-mean()-X tBodyGyro-mean()-Y
#    1:           -0.9066828           -0.9380164           -0.9359358        0.119976160        -0.09179234

#    tBodyGyro-mean()-Z tBodyGyro-std()-X tBodyGyro-std()-Y tBodyGyro-std()-Z tBodyGyroJerk-mean()-X tBodyGyroJerk-mean()-Y
# 1:         0.18962854        -0.8830891        -0.8161636        -0.9408812            -0.20489621           -0.174487710

#       tBodyGyroJerk-mean()-Z tBodyGyroJerk-std()-X tBodyGyroJerk-std()-Y tBodyGyroJerk-std()-Z tBodyAccMag-mean()
#    1:           -0.093389340            -0.9012242            -0.9108601            -0.9392504         -0.8669294

#    tBodyAccMag-std() tGravityAccMag-mean() tGravityAccMag-std() tBodyAccJerkMag-mean() tBodyAccJerkMag-std()
# 1:        -0.7051911            -0.8669294           -0.7051911             -0.9297665            -0.8959942

#    fBodyAcc-mean()-Y fBodyAcc-mean()-Z fBodyAcc-std()-X fBodyAcc-std()-Y fBodyAcc-std()-Z fBodyAcc-meanFreq()-X
# 1:       -0.91821319        -0.7890915       -0.9482903     -0.925136870       -0.6363167            0.01111695

# ...

# Load and process X_train & y_train data tocreate tidy data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt") # load 'x_train.txt' dataset; (large dataset, takes a little time)

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") # load 'y_train.txt' dataset

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")  # load 'subject_train.txt' dataset

names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features_mean_std]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]               # lookup description for y_train code
names(y_train) = c("Activity_ID", "Activity_Label")      # column headers
names(subject_train) = "subject"                         # subject = patient ID

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train) # for each subject get training data

# Merge test and train data
comb_data = rbind(test_data, train_data)                      # combine the two datasets

id_labels   = c("subject", "Activity_ID", "Activity_Label") # id variables for melt function
data_labels = setdiff(colnames(data), id_labels)            # measure variables for melt funtion
melt_data   = melt(comb_data, id = id_labels, measure.vars = data_labels) 

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data_rowName_False.txt",row.name=FALSE)  # write the final result (tidy_data) to a file in the 
                                                  # root directory called 'tidy_data.txt'
write.table(tidy_data, file = "./tidy_data.txt")

