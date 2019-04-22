#!/bin/bash
# Loops into subjects directorties to find rest_motion_fd_summary_stats.csv that was created 
# and calls Summary_csv_looper.py to extract the mean value and place it in a general csv.
# Fully reproducible

# Insert subject id you want to process
sublist="0051459 0051460 0051460_copy 0051470"

# Insert rootpath were all CALTECH subject data is stored
rootpath=/Users/stavrostrakoshis/Documents/Caltech_scans



# Loop over subjects
for subid in $sublist
do
    # Path for specific subject to process
    subpath=$rootpath/$subid
    preprocpath1=$subpath/session_1/preproc_1
    preprocpath2=$subpath/session_1/preproc_2
    # Check if there is preproc_2 which would mean the subject was preprocessed with cost_function=lp+
    if [ -d $preprocpath2 ]
    	then

    # Change directory to $preprocpath2
    cd $preprocpath2

	# Call py script 
	python3 $rootpath/Code/Summary_csv_looper.py
	
	# If there is no preproc_2 then there should be a preproc_1
	elif [ -d $preprocpath1 ]
	   then

	# Change directory to $preprocpath1
	cd $preprocpath1

	# Call py script
	python3 $rootpath/Code/Summary_csv_looper.py
	
	# Maybe there is nothing
	else

	echo "**ERROR: There is no preproc_1 nor preproc_2 for ${subid} but loop will continue**"
fi



	# Back to rootpath
	echo 'Subject' ${subid} 'done, back to rootpath'
	cd $rootpath

done
