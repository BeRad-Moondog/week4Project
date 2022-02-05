# week4Project
#This project takes data from Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 

#The R code for this project is contained in the downloadable file run_analysis.R The code provides an easily understandable narrative for the analysis by segmenting the code in steps.

#Create the activity and features tables <----**This describes what each segments does**
        activityLabels<-"./UCI HAR Dataset/activity_labels.txt" %>%read.table()
                        colnames(activityLabels)<-c("aNDX","activity name")
                
        features<-"./UCI HAR Dataset/features.txt"%>%read.table()
#
