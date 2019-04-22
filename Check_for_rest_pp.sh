#!/bin/bash

#check whether there is rest pp in preproc
#move entire sub dir to DELETED in site if not

#This is step 2, step 1 is Check_preproc_dirs.sh


sitelist="Yale_scans"

#SITES DONE: Caltech_scans_less, KKI, Leuven_1, Leuven_2, MaxMun, NYU
# 				Olin, Oregon, Pitt, SanDiego, SBL, Stanford, Trinity
#				UCLA_2 UM_1, UM_2, USM_Scans

rootpath=~/Documents/ABIDE_1

for site in $sitelist
do
	sitepath=$rootpath/$site

	dest=$sitepath/DELETED
	mkdir $dest

	cd $sitepath


	subjlist=$(printf '%s\n' [0-9]* | paste -sd " ")

	for sub in $subjlist
	do
		subpath=$sitepath/$sub/session_1/preproc_*

		cd $subpath

		#if rest pp in preproc doesn't exist
		if [ ! -f rest_pp.nii.gz ]
			then
			echo "**+$sub in $site doesn't have a rest pp - will be moved to DELETED"
			cd $sitepath

			#moves sub dir
			mv $sub $dest
		fi

		cd $sitepath

	done

	cd $rootpath

done
