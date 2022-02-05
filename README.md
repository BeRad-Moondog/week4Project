# week4Project
#This project takes data from Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 

#The R code for this project is contained in the downloadable file run_analysis.R The code provides an easily understandable narrative for the analysis by segmenting the code in steps.

# Do the data files exist in the working directory. if not then down load the compressed file and unzip.  ** <----Description of Segment from Narrative**
    dirlist<-c("./UCI HAR Dataset","./UCI HAR Dataset/test","./UCI HAR Dataset/train",
               "./UCI HAR Dataset/test/Inertial Signals","./UCI HAR Dataset/train/Inertial Signals")
    if (!sum(dir.exists(dirlist))==length(dirlist)){
      fn<-new.wd.dir %>% paste("project_dataSet.zip",sep="")
      fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
      download.file(fileURL,fn,method="auto",cacheOK=FALSE)
      unzip(fn)
    }
# 
