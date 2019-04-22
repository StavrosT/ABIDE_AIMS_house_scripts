#!/bin/bash
# This script calculates how many volumes exist in each subject's 
# EPI by site, before preprocessing. 
# Depends on AFNI's 3dinfo. For ABIDE.
#
# 27.09.2018 Stavros Trakoshis

#Name of csv for output
#Output will be saved in rootpath
Outname="Nvols_site_subject"


#Sitelist
Sitelist="MRC_AIMS" 

#which ABIDE?
ABIDE=ABIDE_1
#Sitepath
Rootpath=~/Documents/$ABIDE

#printing stuff in bash 
printf "**+ Will be processing $ABIDE at these sites+**\n${Sitelist} +**\n%.0s" {1..3}

#external loop
for site in $Sitelist
do
	echo "**+ Processing of $site begins +**"
	Sitepath=$Rootpath/$site/rsfMRI/raw_data

	cd $Sitepath

	#print all subjects
	#subjects directories start with an integer
	#no other directories do
	#in ABIDE_2 subjects dont start with 0
	#thats why we have all integers here
	 echo -e "**+ These are the subjects +**\n$(printf '%s\n' [0-9]*)"
	 Subjlist=$(printf '%s\n' [0-9]*)

	 #internal loop
	 for sub in $Subjlist
	 do

	 	echo "**+ In $sub of $site"
	 	Subpath=$Sitepath/$sub
	 	EPIpath=$Subpath
	 	cd $EPIpath
	 	echo $sub
	 	#call 3dinfo to find n vols
	 	3dinfo -nv rest.nii.gz
	 	#save it into a variable
	 	Nvols=$(3dinfo -nv rest.nii.gz)


	 	#Now print and paste everythind
	 	#col-wise into a csv
	 	#in a different row every time
	 	#voila

	 	printf '%s\n' $site $sub $Nvols | paste -sd ',' >> $Rootpath/${Outname}.csv

	 	cd $Sitepath
	 done #internal loop
	 

	 cd $Rootpath

	done #external loop

	echo "**+ DONE +**"

read -p "Do you want to open the resulting csv with gedit? [n/Y]: " EXPRESSION

if [ "$EXPRESSION" == "Y" ]
	then
	gedit $Rootpath/${Outname}.csv
else
	echo "Alright! Exiting.."
fi







