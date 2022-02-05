
#Administrative Header
    rm(list=ls())
    library(tidyverse)
#
    
    
# Set Directory Location
    new.wd.dir<-"C:/data/BeRad Research/Education/Johns Hopkins/Certifications/Data Science/WD/GettingData/Project/Data/"
    new.wd.dir %>% setwd()
#
    
    
    
# Do the data files exist in the working directory in not down load the compressed file and un zip
    dirlist<-c("./UCI HAR Dataset","./UCI HAR Dataset/test","./UCI HAR Dataset/train",
               "./UCI HAR Dataset/test/Inertial Signals","./UCI HAR Dataset/train/Inertial Signals")
    
    if (!sum(dir.exists(dirlist))==length(dirlist)){
      fn<-new.wd.dir %>% paste("project_dataSet.zip",sep="")
      fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
      download.file(fileURL,fn,method="auto",cacheOK=FALSE)
      unzip(fn)
    }
# 
    
    
    
#Create the activity and features tables
        activityLabels<-"./UCI HAR Dataset/activity_labels.txt" %>%read.table()
                        colnames(activityLabels)<-c("aNDX","activity name")
                
        features<-"./UCI HAR Dataset/features.txt"%>%read.table()
#
        
#Filter the features table to remove all information not related to mean and std...remove features to tidy the memory preserve index
        statFeatures<-features %>% filter((grepl("*.-mean()*",V2) | grepl("*.-std()*",V2)) & !grepl("*meanFreq*",V2)); 
        colnames(statFeatures)<-c("fNDX","feature name") #Preserves connection between features and file index
rm("features")
#
#Create clearer feature names.
        xs<-separate(statFeatures,"feature name",c("feature","statf","cartesian"),sep="-")
              xs["std" %>% grepl(.,xs$statf),which(colnames(xs)=="statf")]<-"std"    #rids the () from std()
              xs["mean" %>% grepl(.,xs$statf),which(colnames(xs)=="statf")]<-"mean"  #rids the () from mean()
              xs[is.na(xs[,which(colnames(xs)=="cartesian")]),which(colnames(xs)=="cartesian")]="XYZ" #rids the <NA> from the cartesian
              featureNames<-paste(xs[,which(colnames(xs)=="cartesian")],"-",xs[,which(colnames(xs)=="feature")],"-",xs[,which(colnames(xs)=="statf")],sep="")
rm("xs")       
#
      
# Create (X) test and train tables
              x_train<-"./UCI HAR Dataset/train/X_train.txt"%>%read.table()
              x_test<-"./UCI HAR Dataset/test/X_test.txt"%>%read.table()
              
                    #Preserve the information regarding the distinction between training and actual testing experiments
                        #x_train<-x_train %>% mutate (exp_type="train")
                        #x_test<-x_test %>% mutate (exp_type="test")
                        
                    #
                    # Limit X to only those columns that have the desired Stat Features
                        
 #
 # Combine test and train information and remove columns that do not provide project relevant stat features
              X<-x_train %>% rbind(x_test)
              X<-X[,statFeatures$fNDX]
              names(X)<-featureNames
 #
rm("x_train","x_test","statFeatures")  #tidy the memory

       
# Create (Y) test and train tables
       y_train<-"./UCI HAR Dataset/train/y_train.txt" %>% read.table()  
       y_test<-"./UCI HAR Dataset/test/y_test.txt" %>% read.table()
       
                  #Preserve the information regarding the distinction between training and actual testing experiments
                      y_train<-y_train %>% mutate (exp_type="train")
                      y_test<-y_test %>% mutate (exp_type="test")
       
                  #
#
# Combine Y test and train information
       Y<-y_train%>% rbind(y_test) 
#
# Add the Activity Labels to Y
       
       for (i in 1:dim(activityLabels)[1]){  #Loop through activity levels
         Y[Y==i,1]<-activityLabels[i,2]   
         
       }
#
       
# Name the Y's columns
       names(Y)<-c("activity","exp_type")  
#
rm("y_train","y_test","activityLabels") #tidy the memory


# Bind Y and X and tidy the memory
     B=cbind(Y,X) 
#
rm("Y","X","featureNames")   #tidy the memory




     
# Create 'average of features' summary data frame. Problem Spec did not distinguish train and test averages
     
     df<-data.frame()
     
     for (i in 3:dim(B)[2]){
       
       C<-cbind(B$activity,B[,i]) %>% as.data.frame()
       fctr<-C$V1 %>% factor()
       fdata<-C$V2 %>% as.numeric()
       fstat<-fdata %>%split(fctr)%>%sapply(mean)
       df[i-2,1]<-names(B)[i]
       df[i-2,2]<-"average"
       df[i-2,3]<-fstat[[1]]%>% round(3)
       df[i-2,4]<-fstat[[2]]%>% round(3)
       df[i-2,5]<-fstat[[3]]%>% round(3)
       df[i-2,6]<-fstat[[4]]%>% round(3)
       df[i-2,7]<-fstat[[5]]%>% round(3)
       df[i-2,8]<-fstat[[6]]%>% round(3)
       names(df)<-c("Feature","Calculation","LAYING","SITTING","STANDING","WALKING","WALKING_DOWN_STAIRS","WALKING_UPSTAIRS")
     }
rm("i","fctr","fdata","fstat","C")
  
#save information into files
write_excel_csv(B, "week4data.csv") 
write_excel_csv(df,"averageFeaturesSummary.csv")

rm(list=ls())  #the tidiest memory without quitting RStudio
     
    