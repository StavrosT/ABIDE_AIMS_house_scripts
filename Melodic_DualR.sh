#!/bin/bash
#
#This script runs the fsl functions melodic and dual_regression
#

#Insert rootpath
rootpath=~/Documents/ABIDE_1/MRC_AIMS/rsfMRI/raw_data
#Insert Subject list where EPI will be read from
subjlist="12007 12009"

#Insert name of group to process and make dir for it
Group_name="TDmN"

# OVERALL Destination path
destpath=$rootpath/MELODIC
mkdir $destpath

# Group destination path
G_dest=$destpath/${Group_name}
mkdir $G_dest

#Insert preprocessed EPI of interest for Melodic list
EPI="LG_3DR_Erest_pp.nii.gz"

cd $rootpath

for subid in $subjlist
do
	subpath=$rootpath/$subid
	preprocpath=$subpath/preproc_2
	cd $preprocpath
	echo "I am in ${subid}"

	#for macs is greadlink -f after brew install coreutils
	#reads file link and sends it to a list
	readlink -f $EPI
	echo $(readlink -f $EPI) >> ${destpath}/${Group_name}.txt
	cd $rootpath
done #for

#Go to Destpath
cd $destpath

#change groupname.txt to .filelist
#cp ${Group_name}.txt ${Group_name}.filelist


# Format melodic args
INPUT=${Group_name}.txt
TR="1.302"
DIMS="10"
ARGS="--tr=$TR --dim=$DIMS --Oall --report -v --nomask  --nobet --bgthreshold=1 --logPower=1"

# Call melodic
melodic -i ${Group_name}.txt -o $G_dest $ARGS
#**************
#Consider running AROMA in MELODIC output
#*********

cp ${Group_name}.txt $G_dest

#cd to group destination path
cd $G_dest

#dual_regressions args can be entered here but in my UBUNTU versions it works only hard coded
#ADD arguments such as 1=variance normalized, -1=One sample t-test, 100=permutations



# Running Dual Regression in Group ICA
echo "Dual Regression about to Start"
# run dual_regression, 

dual_regression melodic_IC.nii.gz 1 -1 100 Dual_r `cat ${Group_name}.txt`

#echo done 10 times
printf "**  DONE - DONE - DONE **\n%.0s" {1..10}