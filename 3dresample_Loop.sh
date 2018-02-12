#!/bin/bash

sublist="12004 12005" #12005 12004 12006 12007 12008 12009 12010 12011" # 12015 12016 12017 12018 12021 12022 12023 12025 12026 12027 12028 12029 12030 22022 22023 22025 22026 22027 22030 22031 22034 22035 22037 22038 22039 22040 22041 22043 22044 22045 22046 22047 22050  32001 32002 32003 32004 32005 32007 32008 32009 32010 32012 32013 32014 32015 32017 32018 32020 32021 32022 32023 32024" #12015 12016 12017 12018 12021 12022 12023 12025 12026 12027 12028 12029 12030 12031 12032 12034 12036 12037 12038 12040 22001 22002 22005 22006 22007 22009 22012 22013 22015 22017 22019 22021 22022 22023 22025 22026 22027 22030 22031 22034 22035 22037 22038 22039 22040 22041 22043 22044 22044 22045 22046 22047 22049 22050 32001 32002 32003 32004 32005 32007 32008 32009 32010 32012 32013 32014 32015 32017 32018 32020 32021 32022 32023 32024 32025 32026 32027 32028 32030 32031 32032 32034 32035 32036 32037 32038 42006 42011"

# insert rootpath were all CALTECH subject data is stored
rootpath=/Users/stavrostrakoshis/Documents/MRC_AIMS/rsfMRI/raw_data
atlasroot=/Users/stavrostrakoshis/rsfmri/Templates/GlasserHCP 
atlasfile=$atlasroot/MMP_in_MNI_symmetrical_1.nii.gz
# loop over subjects
for subid in $sublist
do
	# Path for each id
	 subpath=$rootpath/$subid
	 preprocpath2=$subpath/preproc_2


	 
	 cd $preprocpath2

	 #3dresample is called 
	 3dresample -master Erest_pp.nii.gz -prefix Erest_TEMP.nii.gz -input $atlasfile

	 #if exit status is 0 make a directory with the resulting image
	 #else throw error and move to the nex subject
	 
	 if [ $? -eq 0 ]
	 	then
		mkdir HURSTS && cp Erest_TEMP.nii.gz HURSTS && ls HURSTS

		rm Erest_TEMP.nii.gz


		else

		echo "ERROR! 3dresample for ${subid} did not comence! ERROR"
	fi
	cd $rootpath
done