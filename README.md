Getting-and-Cleaning-Data
=========================

This repository contains documents and codes related to the Coursera "data cleaning" project
The project is based on the "Human Activity Recognition Using Smartphones" Dataset

There R script included in here called "run_analysis.R" reads the raw data from the "Human Activity Recognition Using Smartphones" Dataset. It first pieces the training and test raw data together. Since the raw data does not have variable labels, it reads a "features" table and labels labels the data. Further it aligns the raw data with activity labels that it gets from a list of activity labels stored in a text file. It aligns the raw data with subjects who underwent the experiment.
Once all that is done it subsets columns that contain mean and standard deviation values. Finally it summarizes the mean and standard deviation values into average values by the subjects, where a subject is a unit of analysis (or an atomic value) in the data table. In short, the purpose of the program can be described as creating a "tidy" analytic file in which a subject is represented as an experimental unit. 

Credits:
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
