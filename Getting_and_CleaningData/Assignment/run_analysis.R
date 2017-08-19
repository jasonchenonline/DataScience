library(dplyr)
library(data.table)
#1. Extract Data
DT_feature  <- setDT(read.table("./Data_HAP/features.txt"))
DT_activity <- setDT(read.table("./Data_HAP/activity_labels.txt"))

DT_X_train  <- setDT(read.table("./Data_HAP/train/X_train.txt"))
DT_subject0 <- setDT(read.table("./Data_HAP/train/subject_train.txt"))
DT_Y_train  <- setDT(read.table("./Data_HAP/train/y_train.txt"))

DT_X_test   <- setDT(read.table("./Data_HAP/test/X_test.txt"))
DT_subject1 <- setDT(read.table("./Data_HAP/test/subject_test.txt"))
DT_Y_test   <- setDT(read.table("./Data_HAP/test/y_test.txt"))

#2. Transform
flagMeasurement <- function (data) {
  pattern <- c("mean\\(\\)","std\\(\\)")
  x <- grepl( paste(pattern, collapse = "|"), data, ignore.case = TRUE)
  x
}

#2.1 Filtering only mean() and Std()
DT_feature[, flag:= mapply(flagMeasurement, V2)]
DT_feature<- DT_feature[ DT_feature$flag == TRUE, ]

col_Indexs <- DT_feature$V1
col_Names  <- sapply(DT_feature$V2, as.character)
DT_X_train <- DT_X_train[, col_Indexs, with = FALSE]
DT_X_test  <- DT_X_test[, col_Indexs, with = FALSE]

names(DT_X_train) <- col_Names
names(DT_X_test) <- col_Names

#3. Join Activity to Measurment, Apply descriptive names to Activity
activityList <- sapply(DT_activity$V2, as.character)
names(activityList) <- DT_activity$V1
DT_Y_train[, Activity :=  activityList[V1] ]
DT_Y_test [, Activity :=  activityList[V1] ]

DT_train <- cbind(DT_Y_train[,Activity], DT_X_train)
DT_test  <- cbind( DT_Y_test[,Activity], DT_X_test)
names(DT_subject0) <- c("SubjectId")
names(DT_subject1) <- c("SubjectId")
DT_train <- cbind ( DT_subject0[, SubjectId], DT_train)
DT_test <- cbind( DT_subject1[, SubjectId], DT_test)
col_Names2 <- c("SubjectId", "Activity")
names(DT_train) <- c(col_Names2, col_Names)
names(DT_test) <- c(col_Names2, col_Names)

# 3.5 merge DT_train and DT_test
#Total <- merge( DT_train, DT_test, by="SubjectId")
Total <- rbind ( DT_train, DT_test )


#4. Apply descriptive labels to variables
x <- colnames(Total)
x <- sub("^t", "time.", x)
x <- sub("^f", "freq.", x)
x <- sub("-X$", ".X", x)
x <- sub("-Y$", ".Y", x)
x <- sub("-Z$", ".Z", x)
x <- sub("-mean\\(\\)", ".mean", x)
x <- sub("-std\\(\\)", ".std", x)
x <- sub("\\(\\)", "", x)
names(Total) <- x
write.table(Total, file = "Total.csv", sep = ",", qmethod = "double")

#5 tidy data
y<- x[c(1,2)]  #all column except SubjectId and Activity
tidy <- Total %>% 
  group_by( SubjectId, Activity) %>%
   summarise_each( funs(mean), y)
write.table(tidy, file = "tidyTotal.txt", sep = " ", qmethod = "double", row.names = FALSE)

tidyTotal <- setDT(read.table("tidyTotal.txt", sep=",", header = TRUE))