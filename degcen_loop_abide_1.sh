#!/bin/bash
#This script creates a whole brain mask with 3dAutomask of rest_pp and then uses it in degcen.py
#to calculate egree centrality in the whole brain - voxelwise of the rest_pp with the mask.

#11/04/2019

#Stavros Trakoshis


#Enter ABIDE 1 site(s)
SITES="Leuven_1 UCLA_1 UCLA_2 Pitt"
#DONE: KKI Leuven_2 NYU PITT Olin Stanford Oregon SanDiego Trinity SBL Yale_scans Caltech_scans_less MaxMun UM1 UM2 USM_Scans

#Not DONE: Leuven_1 UCLA_1 UCLA_2 Pitt


#Enter EPIs name
imgfile=rest_pp.nii.gz


#Enter mask outname
maskfile=afni_whole_brain_mask.nii.gz


#Enter dgcen.py outname
outfile=degcenpy.nii.gz





#rootpath
abide_1_path=~/Documents/ABIDE_1
cd $abide_1_path

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
	sitepath=$abide_1_path/$i
	#destination of site
	sitedest=$destpath/$i

	mkdir $sitedest


	cd $sitepath
	sublist=$(printf "%s\n" [0-9]*)

	#sub loop
	for sub in $sublist
	do
		#path to preproc dir
		preprocpath=$sitepath/$sub/session_1/preproc_*
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

	cd $abide_1_path


done #siteloop ends

