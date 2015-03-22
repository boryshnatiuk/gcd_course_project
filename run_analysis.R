
location = "UCI HAR Dataset"

#DATA

data_columns <- read.table(paste0(location,"/features.txt"))
train_data <- read.table(paste0(location,"/train/X_train.txt"), col.names = data_columns$V2)
test_data <- read.table(paste0(location,"/test/X_test.txt"), col.names = data_columns$V2)
train_and_test_data <- rbind(train_data, test_data)


#LABELS

activity_labels <- read.table(paste0(location,"/activity_labels.txt"), col.names = c("label","activity"))
train_labels <- read.table(paste0(location,"/train/y_train.txt"), col.names = "label")
test_labels <- read.table(paste0(location,"/test/y_test.txt"), col.names = "label")
all_labels <- rbind(train_labels, test_labels)
train_and_test_activities <- merge(all_labels, activity_labels, by.x = "label", by.y = "label", all=T)



#SUBJECTS

train_subjects <- read.table(paste0(location,"/train/subject_train.txt"), col.names = "subject")
test_subjects <- read.table(paste0(location,"/test/subject_test.txt"), col.names = "subject")
train_and_test_subjects <- rbind(train_subjects, test_subjects)
unique(train_and_test_subjects)


#FULL DATASET

full_data <- cbind(train_and_test_subjects, train_and_test_activities, train_and_test_data)


#FILTER COLUMNS

include_columns <- names(full_data)[grepl("mean\\.|std",names(full_data))]
sample_data <- full_data[,c("subject", "activity", include_columns)]
str(sample_data)

names(sample_data) <- gsub("\\.+","_",names(sample_data))
names(sample_data) <- sub("_$","",names(sample_data))
str(sample_data)


#AGGREGATING DATA
library(reshape2)
sample_melt <- melt(sample_data[,1:5], id = c("subject","activity"))
sample_data_avg <- dcast(sample_melt, subject + activity ~ variable, mean)
str(sample_data_avg)

write.table(sample_data_avg, file = "clean_data_aggreagted.txt", row.names=F)

