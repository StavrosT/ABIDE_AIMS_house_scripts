#!/bin/bash

#This script uses extensive bet on specified mprage images - in ABIDE data

#This is sometimes necessary because of the different ages of subjects 
#different fractional intensity is needed than the default of 0.5.
#or other parameters

#Specify bet parameters in the OPTIONS variable

#This script is also using fsleyes or afni to show you the results
#for N seconds before the process is killed


#specify viewing time in the Nseconds variable - integer

#this is for complementary use with speedyppX.py
# De-noising module adapted for motion artifact removal by Patel, AX. (2014).



List="0051212"
#Path for directories
rootpath=/Volumes/VERBATIM_HD/UCLA_1

#cd into path
cd $rootpath

#Specify bet options

OPTIONS="-R -S -B -v "

#Specify how many seconds you want to view the beted image

Nseconds="20"

#Loop
for i in $List
do


	#cd into individual directory
	subpath=$rootpath/$i/session_1
	preprocpath=$subpath/preproc_2
	STRpreprocpath=$(echo ${preprocpath})
	cd $subpath


	#Make a directory for the second pipeline to run
	mkdir preproc_2 

	#Bring the images here
	cp anat_1/mprage.nii.gz preproc_2 && cp rest_1/rest.nii.gz preproc_2 

	#cd in new directory
	cd preproc_2 

	#Check if dir was made
	DIR=$(pwd)
	STRdir=$(echo ${DIR})
	if [ ${STRdir} = ${STRpreprocpath} ]
		then
		echo "Script in preproc_2 of ${i} now, ready to unleash bet."
	else
	echo "+ERROR preproc_2 for ${i} was notmade."
fi
	
	#Call bet. 
	bet mprage.nii.gz mprage.nii.gz ${OPTIONS}

	#Can we see the image from a bash script? 

	if [ -x $FSLDIR/bin/fsleyes ]
		then
		fsleyes mprage.nii.gz &
	else
		afni mprage.nii.gz &
	fi
	
	#You get to view the image for Nseconds
	sleep $Nseconds

	#Thats enough - kill background process by name
	echo "The image viewers are shutting down"

	kill $(ps aux | grep fsleyes | awk '{print $2}') || kill $(ps aux | grep afni | awk '{print $2}')
	

	#echo something to remove the hang
	echo "No background process should be alive now. ${i} BET is done, moving to the next one"
	##Insert abide run 2 lpc+ pipeline?

	cd $rootpath

done
