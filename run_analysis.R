X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Requirement 4, Labels the data set with descriptive variable name
# It is reasonal to use the variable names from the data files except 
# these which are unavailable. 
# Since I am using the label names to find columns for mean and std,
# I do step 4 before 1, 2 & 4
# Giving variable a label early will also help data merging.
name <- read.table("UCI HAR Dataset/features.txt")
label <- read.table("UCI HAR Dataset/activity_labels.txt")
names(X_train) <- name$V2
names(y_train) <- c("activityLabel")
names(X_test) <- name$V2
names(y_test) <- c("activityLabel")
names(subject_train) <- c("subject")
names(subject_test) <- c("subject")

# Requirement 1: merge training and test sets.
train <- cbind(X_train, y_train, subject_train)
test <- cbind(X_test, y_test, subject_test)
data <- rbind(train, test)

# Requirement 2: extract only the measurements on the mean and standard deviation.
# By changing following line a little bit, we can contain other measurement such as meanFreq, etc.
selected_data <- data[,c("activityLabel", "subject", colnames(data)[grep("\\-mean\\(\\)", colnames(data))], colnames(data)[grep("\\-std\\(\\)", colnames(data))])]

# Requirement 3: label activities using descriptive activity names
selected_data$activityLabel <- label$V2[match(selected_data$activityLabel,label$V1)]

# Requirement 5: Generate tidy data set
dataMelt <- melt(selected_data, id=c("activityLabel", "subject"))
# long form (chosen to use):
tidy <- aggregate(value ~ activityLabel+subject+variable, dataMelt, mean)
names(tidy)[names(tidy) == 'variable'] <- "feature"
names(tidy)[names(tidy) == 'value'] <- "mean"
# wide form (chosen not to use):
# tidy <- dcast(dataMelt, activityLabel + subject ~ variable, mean)