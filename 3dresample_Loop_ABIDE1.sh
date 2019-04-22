#!/bin/bash
#resamples Glasser's template to each pp
#needs one preproc in every subject
#for ABD 1
#depends on AFNI programms 



#insert site list

sitelist="Yale_scans"


#SITES DONE: Caltech_scans_less, KKI, Leuven_1, Leuven_2, MaxMun, NYU,
#				Olin, Oregon, Pitt, SanDiego, SBL, Stanford, Trinity	
#				UCLA_2 UM_1 UM_2, USM_Scans


# insert rootpath
rootpath=/home/stavros/Documents/ABIDE_1

atlasroot=/home/stavros/rsfmri/Templates/GlasserHCP 
atlasfile=$atlasroot/MMP_in_MNI_symmetrical_1.nii.gz


# loop over subjects

for site in $sitelist
do
	sitepath=$rootpath/$site

	cd $sitepath

	sublist=$(printf '%s\n' [0-9]* | paste -sd " ")


	for subid in $sublist
	do
		# Path for each id
		 subpath=$sitepath/$subid
		 preprocpath2=$subpath/session_1/preproc_*


		 
		 cd $preprocpath2

		 echo "** In ${subid} of ${site} ! Ready to start resampling **"

		 #3dresample is called 
		 3dresample -master rest_pp.nii.gz -prefix rest_TEMP.nii.gz -input $atlasfile

		 #if exit status is 0 make a directory with the resulting image
		 #else throw error and move to the nex subject
		 
		 if [ $? -eq 0 ]
		 	then
			mkdir FINALHURSTS && cp rest_TEMP.nii.gz FINALHURSTS && ls FINALHURSTS

			rm rest_TEMP.nii.gz


			else

			echo "**ERROR! 3dresample for ${subid} in ${site} did not comence! ERROR**"
		fi
		
		cd $sitepath

	done

	cd $rootpath


done #outerloop