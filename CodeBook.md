Code Book for run_analysis.R

The script run_analysis.R performs the following steps:

Data is downloaded and unzipped (This step was removed from the script)

Similar data is merged using the rbind() function. Similar data in files have the same number of columns and parameters.

Columns with the mean and standard deviation measures are extracted from the merged dataset and given names taken from features.txt.

Activity names and IDs in merged datastet are replaced from activity_labels.txt.

Column names are then updated to a more readable format.

The data id output to a file tidyfile.txt.  This file has been uploaded into the repository.
