#!/bin/bash

#check whether there is one preproc in each subject

#I then manually check and delete the unecessary preproc and add the 
#site to the SITES DONE section

#This is step 1, step 2 is Check_for_pp.sh


sitelist="Yale_scans"

#SITES DONE: Caltech_scans_less, KKI, Leuven_1, Leuven_2, MaxMun, NYU
#				Olin, Oregon, Pitt, SanDiego. SBL, Stanford, Trinity
#			UCLA_2, UM_1, UM_2, USM_Scans




rootpath=~/Documents/ABIDE_1

for site in $sitelist
do
	sitepath=$rootpath/$site

	cd $sitepath


	subjlist=$(printf '%s\n' [0-9]* | paste -sd " ")

	for sub in $subjlist
	do
		subpath=$sitepath/$sub/session_1

		cd $subpath

		Nproc=$(printf '%s\n' preproc* | paste -sd " ")

		number=$(echo $Nproc | wc -w) #-w counts words according to newline


		if [ $number != 1 ]
			then
			echo "**+$sub in $site has more than 1 preproc dirs"
		fi

		cd $sitepath

	done

	cd $rootpath

done



