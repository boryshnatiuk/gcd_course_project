---
output:
  html_document:
    toc: yes
---

__CODE BOOK__
====

This document will describe the processes and transformations involved made in this project.


### __Loading datasets__
#### Raw data
```
location = "gcd_course_project/UCI HAR Dataset"
data_columns <- read.table(paste0(location,"/features.txt"))
train_data <- read.table(paste0(location,"/train/X_train.txt"), col.names = data_columns$V2)
test_data <- read.table(paste0(location,"/test/X_test.txt"), col.names = data_columns$V2)
```
#### Labels
```
location = "gcd_course_project/UCI HAR Dataset"
activity_labels <- read.table(paste0(location,"/activity_labels.txt"), col.names = c("label","activity"))
train_labels <- read.table(paste0(location,"/train/y_train.txt"), col.names = "label")
test_labels <- read.table(paste0(location,"/test/y_test.txt"), col.names = "label")
```
#### Subjects
```
location = "gcd_course_project/UCI HAR Dataset"
train_subjects <- read.table(paste0(location,"/train/subject_train.txt"), col.names = "subject")
test_subjects <- read.table(paste0(location,"/test/subject_test.txt"), col.names = "subject")
```


### __Merging datasets__
Merging:

1. train and test raw data
    ```
        train_and_test_data <- rbind(train_data, test_data)
    ```
2. train and test labels
    ```
        all_labels <- rbind(train_labels, test_labels)
    ```
3. raw data and labels
    ```
        train_and_test_activities <- merge(all_labels, activity_labels, by.x = "label", by.y = "label", all=T)
    ```
4. train and test subjects
    ```
        train_and_test_subjects <- rbind(train_subjects, test_subjects)
    ```
5. raw data with labels and subjects
    ```
        full_data <- cbind(train_and_test_subjects, train_and_test_activities, train_and_test_data)
    ```


### __Raw Data Transformations__
#### Filtering columns
As described in the project we need columns with mean ans standard deviation metrics only.
```
include_columns <- names(full_data)[grepl("mean\\.|std",names(full_data))]
sample_data <- full_data[,c("subject", "activity", include_columns)]
```

We can check column names with `names(sample_data)` where result is:
```
 [1] "subject"                     "activity"                    "tBodyAcc.mean...X"           "tBodyAcc.mean...Y"          
 [5] "tBodyAcc.mean...Z"           "tBodyAcc.std...X"            "tBodyAcc.std...Y"            "tBodyAcc.std...Z"           
 [9] "tGravityAcc.mean...X"        "tGravityAcc.mean...Y"        "tGravityAcc.mean...Z"        "tGravityAcc.std...X"        
[13] "tGravityAcc.std...Y"         "tGravityAcc.std...Z"         "tBodyAccJerk.mean...X"       "tBodyAccJerk.mean...Y"      
[17] "tBodyAccJerk.mean...Z"       "tBodyAccJerk.std...X"        "tBodyAccJerk.std...Y"        "tBodyAccJerk.std...Z"       
[21] "tBodyGyro.mean...X"          "tBodyGyro.mean...Y"          "tBodyGyro.mean...Z"          "tBodyGyro.std...X"          
[25] "tBodyGyro.std...Y"           "tBodyGyro.std...Z"           "tBodyGyroJerk.mean...X"      "tBodyGyroJerk.mean...Y"     
[29] "tBodyGyroJerk.mean...Z"      "tBodyGyroJerk.std...X"       "tBodyGyroJerk.std...Y"       "tBodyGyroJerk.std...Z"      
[33] "tBodyAccMag.mean.."          "tBodyAccMag.std.."           "tGravityAccMag.mean.."       "tGravityAccMag.std.."       
[37] "tBodyAccJerkMag.mean.."      "tBodyAccJerkMag.std.."       "tBodyGyroMag.mean.."         "tBodyGyroMag.std.."         
[41] "tBodyGyroJerkMag.mean.."     "tBodyGyroJerkMag.std.."      "fBodyAcc.mean...X"           "fBodyAcc.mean...Y"          
[45] "fBodyAcc.mean...Z"           "fBodyAcc.std...X"            "fBodyAcc.std...Y"            "fBodyAcc.std...Z"           
[49] "fBodyAccJerk.mean...X"       "fBodyAccJerk.mean...Y"       "fBodyAccJerk.mean...Z"       "fBodyAccJerk.std...X"       
[53] "fBodyAccJerk.std...Y"        "fBodyAccJerk.std...Z"        "fBodyGyro.mean...X"          "fBodyGyro.mean...Y"         
[57] "fBodyGyro.mean...Z"          "fBodyGyro.std...X"           "fBodyGyro.std...Y"           "fBodyGyro.std...Z"          
[61] "fBodyAccMag.mean.."          "fBodyAccMag.std.."           "fBodyBodyAccJerkMag.mean.."  "fBodyBodyAccJerkMag.std.."  
[65] "fBodyBodyGyroMag.mean.."     "fBodyBodyGyroMag.std.."      "fBodyBodyGyroJerkMag.mean.." "fBodyBodyGyroJerkMag.std.." 
```

The column names have to be cleaned from dots '.'
```
names(sample_data) <- gsub("\\.+","_",names(sample_data))
names(sample_data) <- sub("_$","",names(sample_data))
```

New column names:
```
 [1] "subject"                   "activity"                  "tBodyAcc_mean_X"           "tBodyAcc_mean_Y"           "tBodyAcc_mean_Z"          
 [6] "tBodyAcc_std_X"            "tBodyAcc_std_Y"            "tBodyAcc_std_Z"            "tGravityAcc_mean_X"        "tGravityAcc_mean_Y"       
[11] "tGravityAcc_mean_Z"        "tGravityAcc_std_X"         "tGravityAcc_std_Y"         "tGravityAcc_std_Z"         "tBodyAccJerk_mean_X"      
[16] "tBodyAccJerk_mean_Y"       "tBodyAccJerk_mean_Z"       "tBodyAccJerk_std_X"        "tBodyAccJerk_std_Y"        "tBodyAccJerk_std_Z"       
[21] "tBodyGyro_mean_X"          "tBodyGyro_mean_Y"          "tBodyGyro_mean_Z"          "tBodyGyro_std_X"           "tBodyGyro_std_Y"          
[26] "tBodyGyro_std_Z"           "tBodyGyroJerk_mean_X"      "tBodyGyroJerk_mean_Y"      "tBodyGyroJerk_mean_Z"      "tBodyGyroJerk_std_X"      
[31] "tBodyGyroJerk_std_Y"       "tBodyGyroJerk_std_Z"       "tBodyAccMag_mean"          "tBodyAccMag_std"           "tGravityAccMag_mean"      
[36] "tGravityAccMag_std"        "tBodyAccJerkMag_mean"      "tBodyAccJerkMag_std"       "tBodyGyroMag_mean"         "tBodyGyroMag_std"         
[41] "tBodyGyroJerkMag_mean"     "tBodyGyroJerkMag_std"      "fBodyAcc_mean_X"           "fBodyAcc_mean_Y"           "fBodyAcc_mean_Z"          
[46] "fBodyAcc_std_X"            "fBodyAcc_std_Y"            "fBodyAcc_std_Z"            "fBodyAccJerk_mean_X"       "fBodyAccJerk_mean_Y"      
[51] "fBodyAccJerk_mean_Z"       "fBodyAccJerk_std_X"        "fBodyAccJerk_std_Y"        "fBodyAccJerk_std_Z"        "fBodyGyro_mean_X"         
[56] "fBodyGyro_mean_Y"          "fBodyGyro_mean_Z"          "fBodyGyro_std_X"           "fBodyGyro_std_Y"           "fBodyGyro_std_Z"          
[61] "fBodyAccMag_mean"          "fBodyAccMag_std"           "fBodyBodyAccJerkMag_mean"  "fBodyBodyAccJerkMag_std"   "fBodyBodyGyroMag_mean"    
[66] "fBodyBodyGyroMag_std"      "fBodyBodyGyroJerkMag_mean" "fBodyBodyGyroJerkMag_std" 
```


### __Exporting clean dataset__
Saving the cleaned dataset into _clean_data.txt_ file.
```
write.table(sample_data, file = "gcd_course_project/CourseAssignment/clean_data.txt", row.names=F)
```


### __Creating Aggregated Dataset__
We will create aggregated dataset using the clean data from the above process.
```
sample_melt <- melt(sample_data[,1:5], id = c("subject","activity"))
sample_data_avg <- dcast(sample_melt, subject + activity ~ variable, mean)
```


### __Exporting Aggregated Dataset__
```
write.table(sample_data_avg, file = "gcd_course_project/CourseAssignment/clean_data_aggreagted.txt", row.names=F)
```