#!/bin/bash
#This script creates a whole brain mask with 3dAutomask of rest_pp and then uses it in degcen.py
#to calculate egree centrality in the whole brain - voxelwise of the rest_pp with the mask.

#11/04/2019

#Stavros Trakoshis


#Enter ABIDE 1 site(s)
SITES="MRC_AIMS"
#DONE: 

#Not DONE: 


#Enter EPIs name
imgfile=Erest_pp.nii.gz


#Enter mask outname
maskfile=afni_whole_brain_mask.nii.gz


#Enter dgcen.py outname
outfile=degcenpy.nii.gz





#rootpath
mrc_path=~/Documents/ABIDE_1
cd $mrc_path

#destination path
destpath=~/Documents/ABIDE_1/ABIDE_1_dcbc_whole_brain

if [ ! -d $destpath ]
	then
	mkdir $destpath
fi


#site loop
for i in $SITES
do
	#path to site
	sitepath=$mrc_path/$i/rsfMRI/raw_data
	#destination of site
	sitedest=$destpath/$i

	mkdir $sitedest


	cd $sitepath
	sublist=$(printf "%s\n" [0-9]*)

	#sub loop
	for sub in $sublist
	do
		#path to preproc dir
		preprocpath=$sitepath/$sub/preproc_*
		cd $preprocpath


		#call afni's mask maker
		3dAutomask -q -prefix $maskfile $imgfile


		#call degcen with the weighted option -w 
		python ~/rsfmri-master_mvl/degcen.py -v -i $imgfile -m $maskfile -o $outfile -w

		#copy output to destination
		cp $outfile $sitedest/${sub}_$outfile

		#print some info
		num=$(ls -l $sitedest | wc -l)

		echo "**Files in $sitedest    :                   ${num}"


		cd $sitepath

	done #sublop ends

	cd $mrc_path


done #siteloop ends

