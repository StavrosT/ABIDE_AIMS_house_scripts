#!/bin/bash
# This script removes volumes from fMRI data with fslroi
#fslroi input output tmin tsize
#tmin is a starting timepoint-of-interest and tsize is the length-of-interest
#Example: if there are 498 volumes in a dataset and you want to remove first 8  fslroi rest.nii.gz Erest.nii.gz 8 490
# 490 would be the total of volumes remaining and it deletes up to and including the number provided
# ### Numbering always starts form 0


#Specify data directories
List="42002 42004 42004"
#Path for directories
rootpath=/Users/stavrostrakoshis/Documents/MRC_AIMS/rsfMRI/raw_data
#cd into path
cd $rootpath

#Loop starts
for i in $List
do
	#cd into individual directory
	subpath=$rootpath/$i
	cd $subpath

	#Specify fslroi variables
	tmin=8
	tsize=612

	#Cut Volumes
	fslroi rest.nii.gz Erest.nii.gz $tmin $tsize

	#Are there the desired number of volumes?
	NVOL=$(3dinfo -nv Erest.nii.gz)
	
	#Make this a string
	ENVOL=$(echo "${NVOL}")

	#Doublecheck
	if [ $ENVOL = 612 ]
		then
		echo "${i} has 612 in Erest.nii.gz"
	else
		echo "ERROR in ${i}"
	fi
	cd $rootpath
done  

