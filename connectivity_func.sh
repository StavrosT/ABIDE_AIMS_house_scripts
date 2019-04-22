#!/bin/bash

# '''
# This script takes an a resting state EPI and calculcates various connectivity measure with 
# afni programs (https://afni.nimh.nih.gov), e.g. 3dDegreeCentrality, 3dcalc, 3dResampled
# some fsl functions (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki)
# and standard bash commands.


# You have the option to choose mask, and or template.
#Exampled are fine nthe last 5 lines


# Written and tested on Linux ST-maskachine 4.13.0-46-generic #51-Ubuntu SMP
# x86_64 x86_64 x86_64 GNU/Linux

# Started 20/03/2019
#Finished 21/03/2019

# Stavros Trakoshis
# '''

connectivity_func () {



	OMP_NUM_THREADS=8

	echo "CHECK IF CORRECT   1 arg: EPI, 2 arg : mask.nii.gz or 'binary', \
	 3 arg :  is the number of parcels in case mask is nifti in integer (e.g. 180). If nifti is 'binary' set this to 0, \
	 4 arg : Pearson's R threshold in float (e.g. 0.95), 5 arg is the txt filename you want DC to be saved with extension (name.txt)"

	echo "" 
	echo "" 
	read -t 10 -p "**Press ENTER to continue if the ARGUMENTS are correct (Program will proceed in 10 seconds by itself), otherwise CTRL+C and try again++" ; pwd
	date
	
	# '''
	# Everything is saved in a subject DC directory
	# '''

	
	destpath=./DC
	parc_out=~/Documents/GLOBAL_CONNECTIVITY_PARCELS
	if [ ! -d $parc_out ]
		then
		mkdir $parc_out
	fi

	mkdir $destpath


	# '''
	# 1
	# The first arguments is EPI
	# '''

	echo "+++ EPI info ***"
	fslinfo $1
	fslinfo > $destpath/EPIinfo.txt
	epifname=$1
	# '''
	# 2
	# The number of parcels in template
	# '''
	mask_arg=$2


	# '''
	# 3
	# The number of parcels in template
	# '''
	N_parcels=$3


	# '''
	# 4
	# The fourth argument is the percentage of weights 
	# you want to preserve.
	# You have to provide a float, default here is 95%
	# '''
	threshold=$4

	# '''
	# 5
	# The fifth argument is the filename for the txt
	# if you want a txt file with connectivity
	# '''
	txt_name=$5


	# '''
	# 2
	# The second argument is the mask/template
	# type binary for a binary mask to be created 
	# with afni program 3dAutomask
	#or add your template
	# '''

	#mask condition
	if [ "$mask_arg" == "binary" ]
		then

		echo "**You requested for a binary mask, executing 3dAutomask++"

		#outname
		prefix=${mask_agr}_mask.nii.gz
		#make mask explicitly
		3dAutomask -prefix $prefix $epifname

		cp $prefix $destpath

		#call 3dDegreeCentrality
		3dDegreeCentrality -thresh $threshold -polort -1 -mask $prefix -out1D $txt_name -prefix DC_${epifname} $epifname


		mv DC_${epifname} $destpath
		mv $txt_name $destpath
		#we want to check if there a nii in the mask/template 
	elif [[ $mask_arg == *.nii* ]] #double quotes for wildcards
		then
		echo "**Mask is a nifti on you disk ++"

		#check datatype

		fslhd ${mask_arg} > $destpath/mask_header.txt

		# #read the line that starts with datatype
		# mask_datatype=$(sed -n -e '/datatype/p') mask_header.txt

		# #split text to get the number
		# #delimeter is set to IFS
		# #gets variables var 1 etc that are seperated by the delimeter
		# IFS=' ' read var1 var2 <<< $mask_datatype

		# if [ $var2 > 2 ]
		# 	then


		#resample template



		#N of parcels mast be greater than zero
		if [ $N_parcels > 0 ]
			then
			echo "**Looping over ${N_parcels} parcels++"
			echo ""
			echo "**Individuals parcel's will be temporarily saved in :  ${destpath} +++++++++"
			echo "---------!BY DEFAULT!-----------"
			echo ""

			#parcellation loop
			for parc in $(seq 1 $N_parcels)
			do
				echo "**+ Working on Parcel $parc +**"
				3dcalc -a "$mask_arg" -expr "equals(a,$parc)" -prefix $destpath/Parcel_${parc}.nii.gz



			done #loop ends


			echo "*** Mask Parcel's are getting resampled to EPI +++"

			cp $epifname $destpath
			cd $destpath

			#resample loop
			for i in Parcel_* 
			do
				3dresample -master $epifname -input $i -prefix RES_${i}
				# cp RES_* $destpath
			done #loop ends

			pwd

			rm Parcel_*
			# cd $destpath


			#DegreeCentrality for each, resampled  parcel
			for r in RES_*
			do
				
			
			3dDegreeCentrality -thresh $threshold -polort -1 -mask $r -out1D ${r}_$txt_name -prefix PARC_${r}_DC_${epifname} $epifname
			# cp PARC_${r}_DC_${epifname} $destpath	
			# mv Parc_${r}_${txt_name} $destpath
		done

		rm -Rf RES_*
		rm $epifname

		echo "**DC on every mask parcel is saved in subject ${destpath}++"
		fi #N parcels condition

	else
		echo "**Do not recognise mask"
	fi #mask condition
}

# echo "DONE"


#Chenage accordingly
#Examples UNLOCK ONE or write your own
# connectivity_func Erest_pp.nii.gz binary 0 0.60 connectivity_.txt


# connectivity_func Erest_pp.nii.gz MMP_in_MNI_symmetrical_1.nii.gz 180 0.60 connectivity_.txt

