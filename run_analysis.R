##run_analysis.R *****************/
## This program reads raw data from the                        **/
## Human Activity Recognition Using Smartphones Dataset        **/
## It first pieces the training and test raw data together     **/
## Since the raw data does not have variable labels, it reads  **/
## a "features" table and labels labels the data               **/
## Further it aligns the raw data with activity labels that it **/ 
## gets swfrom a list of activity labels stored in a text file   **/
## It aligns the raw data with subjects who underwent the      **/
## experiment.                                                 **/
## Once all that is done it subsets columns that contain       **/
## mean and standard deviation values.                         **/
## Finally it summarizes the mean and standard deviation values**/
## into average values by the subjects, where a subject is     **/
## a unit of analysis (or an atomic value) in the data table   **/
## In short, the purpose of the program can be described as    **/
## creating a "tidy" analytic file in which a subject is       **/
## represented as an experimental unit.                        **/
##***************************************************************/
## The first order of business is to set the working directory
## to a convinient location
setwd("../Desktop/data science/data cleaning")

## The following two lines read the training and test raw data

trainingdata<-read.table("./UCI HAR Dataset/train/X_train.txt")
testdata<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")

## Read features vector from the features text file

features<-read.table("./UCI HAR Dataset/features.txt")

## Read the activity labels from activity_labels text file

act_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")

## Read the subjects sequence code from the subjects tables - one
## table for the training set and one for the test set

subj_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subj_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

## Start concatenating training and test data

all_data<-rbind(trainingdata, testdata)
subjects<-rbind(subj_train, subj_test)
activities<-rbind(y_train, y_test)

## Now give column names to the raw data using the features vector.
## Further, provide descriptive names for subjects, activities and
## activity labels.

names(all_data)<-features[,2]
names(subjects)<-"Subject"
names(activities)<-"Activity"
names(act_labels)[1]<-"Activity"
names(act_labels)[2]<-"Activity Label"

## Now we are ready to merge (column-bind) all of them together

base_data<-cbind(subjects, activities, all_data)

## In order to perform the next set of tasks efficiently, I would like
## to use the "data.table" package. Therefore set this library and
## set the results as a data table

library(data.table)
base_tab<-data.table(base_data)
actl_tab<-data.table(act_labels)
## The following steps allow merging activity labels and activities (by
## using "Activity" code as key. This will make sure that mistakes are 
## not made while providing descriptive labels to activities.

setkey(base_tab, Activity)
setkey(actl_tab, Activity)

## before merging, subset the variables that are either mean or standard deviations
## This is per the assignment requirements.

t<-subset(base_tab, select=c("Subject","Activity","tBodyAcc-mean()-X","tBodyAcc-mean()-Y","tBodyAcc-mean()-Z","tBodyAcc-std()-X","tBodyAcc-std()-Y","tBodyAcc-std()-Z", "tGravityAcc-mean()-X","tGravityAcc-mean()-Y","tGravityAcc-mean()-Z", "tGravityAcc-std()-X","tGravityAcc-std()-Y","tGravityAcc-std()-Z","tBodyAccJerk-mean()-X","tBodyAccJerk-mean()-Y","tBodyAccJerk-mean()-Z","tBodyAccJerk-std()-X","tBodyAccJerk-std()-Y","tBodyAccJerk-std()-Z","tBodyGyro-mean()-X","tBodyGyro-mean()-Y","tBodyGyro-mean()-Z","tBodyGyro-std()-X","tBodyGyro-std()-Y","tBodyGyro-std()-Z","tBodyGyroJerk-mean()-X",    "tBodyGyroJerk-mean()-Y","tBodyGyroJerk-mean()-Z","tBodyGyroJerk-std()-X","tBodyGyroJerk-std()-Y","tBodyGyroJerk-std()-Z","tBodyAccMag-mean()","tBodyAccMag-std()","tGravityAccMag-mean()","tGravityAccMag-std()","tGravityAccMag-mad()","tBodyAccJerkMag-mean()","tBodyAccJerkMag-std()","tBodyGyroMag-mean()","tBodyGyroMag-std()","tBodyGyroJerkMag-mean()","tBodyGyroJerkMag-std()","fBodyAcc-mean()-X","fBodyAcc-mean()-Y","fBodyAcc-mean()-Z","fBodyAcc-std()-X","fBodyAcc-std()-Y", "fBodyAcc-std()-Z",  "fBodyAcc-meanFreq()-X","fBodyAcc-meanFreq()-Y","fBodyAcc-meanFreq()-Z","fBodyAccJerk-mean()-X","fBodyAccJerk-mean()-Y","fBodyAccJerk-mean()-Z","fBodyAccJerk-std()-X","fBodyAccJerk-std()-Y",	"fBodyAccJerk-std()-Z","fBodyAccJerk-meanFreq()-X","fBodyAccJerk-meanFreq()-Y","fBodyAccJerk-meanFreq()-Z","fBodyGyro-mean()-Y","fBodyGyro-mean()-Z","fBodyGyro-std()-X","fBodyGyro-std()-Y","fBodyGyro-std()-Z","fBodyGyro-meanFreq()-X","fBodyGyro-meanFreq()-Y","fBodyGyro-meanFreq()-Z","fBodyAccMag-mean()","fBodyAccMag-std()",	"fBodyBodyAccJerkMag-meanFreq()","fBodyBodyGyroMag-mean()","fBodyBodyGyroMag-std()","fBodyBodyGyroMag-meanFreq()",	"fBodyBodyGyroMag-skewness()","fBodyBodyGyroJerkMag-mean()","fBodyBodyGyroJerkMag-std()","fBodyBodyGyroJerkMag-meanFreq()","angle(tBodyAccMean,gravity)","angle(tBodyAccJerkMean),gravityMean)","angle(tBodyGyroMean,gravityMean)","angle(tBodyGyroJerkMean,gravityMean)","angle(X,gravityMean)","angle(Y,gravityMean)","angle(Z,gravityMean)"))

## Set key for the subsetted table
setkey(t,Activity)

## Time to merge...
this_tab<-merge(actl_tab, t)
this_tab2<-this_tab
names(this_tab2)<-make.names(seq(ncol(this_tab2)))
names(this_tab2)

## The next set of tasks are best handled using the "dplyr" package. Therefore
## load that package andproceed

library(dplyr)

## The first step is to place the table into a 'data frame tbl' or 'tbl_df'.

worktab<- tbl_df(this_tab2)
 
by_subject_act <- group_by(worktab, X1, X2)
subject_activity_tables <- summarize(by_subject_act,
                                    Activity_name = n_distinct(X3),
                                    Average_X_tBodyAcc_mean = mean(X4), 
					      Average_Y_tBodyAcc_mean = mean(X5),
                                    ?wAverage_Z_tBodyAcc_mean = mean(X6),
                                    Average_X_tBodyAcc_std = mean(X7),
                                    Average_Y_tBodyAcc_std = mean(X8),
                                    Average_Z_tBodyAcc_std = mean(X9),
                                    Average_X_tGravityAcc_mean = mean(X10),
                                    Average_Y_tGravityAcc_mean = mean(X11),
                                    Average_Z_tGravityAcc_mean = mean(X12),
                                    Average_X_tGravityAcc_std = mean(X13),
                                    Average_Y_tGravityAcc_std = mean(X14),
                                    Average_Z_tGravityAcc_std = mean(X15),
                                    Average_X_tBodyAccJerk_mean = mean(X16),
                                    Average_Y_tBodyAccJerk_mean = mean(X17),
                                    Average_Z_tBodyAccJerk_mean = mean(X18),
                                    Average_X_tBodyAccJerk_std = mean(X19),
                                    Average_Y_tBodyAccJerk_std = mean(X20),
                                    Average_Z_tBodyAccJerk_std = mean(X21),
                                    Average_X_tBodyGyro_mean = mean(X22),
                                    Average_Y_tBodyGyro_mean = mean(X23),
                                    Average_Z_tBodyGyro_mean = mean(X24),
                                    Average_X_tBodyGyro_std = mean(X25),
                                    Average_Y_tBodyGyro_std = mean(X26),
                                    Average_Z_tBodyGyro_std = mean(X27),
                                    Average_X_tBodyGyroJerk_mean = mean(X28),
                                    Average_Y_tBodyGyroJerk_mean = mean(X29),
                                    Average_Z_tBodyGyroJerk_mean = mean(X30),
                                    Average_X_tBodyGyroJerk_std = mean(X31),
                                    Average_Y_tBodyGyroJerk_std = mean(X32),
                                    Average_Z_tBodyGyroJerk_std = mean(X33),
                                    Average_tBodyAccMag_me = mean(X34),
                                    Average_tBodyAccMag_s = mean(X35),
                                    Average_tGravityAccMag_me = mean(X36),
                                    Average_tGravityAccMag_s = mean(X37),
                                    Average_tGravityAccMag_m = mean(X38),
                                    Average_tBodyAccJerkMag_me = mean(X39),
                                    Average_tBodyAccJerkMag_s = mean(X40),
                                    Average_tBodyGyroMag_me = mean(X41),
                                    Average_tBodyGyroMag_s = mean(X42),
                                    Average_tBodyGyroJerkMag_me = mean(X43),
                                    Average_tBodyGyroJerkMag_s = mean(X44),
                                    Average_X_fBodyAcc_mean = mean(X45),
                                    Average_Y_fBodyAcc_mean = mean(X46),
                                    Average_Z_fBodyAcc_mean = mean(X47),
                                    Average_X_fBodyAcc_std = mean(X48),
                                    Average_Y_fBodyAcc_std = mean(X49),
                                    Average_Z_fBodyAcc_std = mean(X50),
                                    Average_X_fBodyAcc_meanFreq = mean(X51),
                                    Average_Y_fBodyAcc_meanFreq = mean(X52),
                                    Average_Z_fBodyAcc_meanFreq = mean(X53),
                                    Average_X_fBodyAccJerk_mean = mean(X54),
                                    Average_Y_fBodyAccJerk_mean = mean(X55),
                                    Average_Z_fBodyAccJerk_mean = mean(X56),
                                    Average_X_fBodyAccJerk_std = mean(X57),
                                    Average_Y_fBodyAccJerk_std = mean(X58))

write.table(subject_activity_tables, file="tidy_data.txt", row.name=FALSE)

