# Getting-and-Cleaning-Data-Course-Project
Coursera


Included in this ReadMe file are comments describing the code that can be found in the R script, "run_analysis.R"

Section 1: downloads, unzips, and reads the data using library(downloader).

Section 2: Reads in subject data and changes column name to "subject".

Section 3: Reads in training data and renames columns by features.txt

Section 4: Appends training data to subject data.

Section 5: Reads in activity data and changes data using activity labels. Renames column "activity".

Section 6: Appends activity data to subject/training data.

Section 7: Repeat steps 2-6 for test data.

Section 8: Merge test and training data using rbind.

Section 9: Extracts features that use mean() and std() from data set.

Section 10: Renames all features column names to be more descriptive.

Section 11: Uses library(plyr) to aggregate data by subject and activity.

Section 12: Uses library(memisc) to write codebook.




