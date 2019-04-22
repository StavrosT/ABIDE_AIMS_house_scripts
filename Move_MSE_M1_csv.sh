#!/bin/bash
#resamples Glasser's template to each pp
#needs one preproc in every subject
#for ABD 1
#depends on AFNI programms 



#insert site list

sitelist="Stanford Trinity UCLA_1 UCLA_2 UM_1 UM_2 USM_Scans Yale_scans"
#"Yale_scans Caltech_scans_less KKI Leuven_1 Leuven_2 MaxMun NYU Olin Oregon Pitt SanDiego SBL Stanford Trinity UCLA_2 UM_1 UM_2 USM_Scans

#SITES DONE: Caltech_scans_less, KKI, Leuven_1, Leuven_2, MaxMun, NYU,
#				Olin, Oregon, Pitt, SanDiego, SBL, Stanford, Trinity	
#				UCLA_2 UM_1 UM_2, USM_Scans


# insert rootpath
rootpath=/home/stavros/Documents/ABIDE_1

destpath=~/Documents/ABIDE_1/ALL_sites_MSE_M1
mkdir $destpath


# loop over subjects

for site in $sitelist
do
	sitepath=$rootpath/$site

	sitedest=$destpath/${site}_MSE_M1
	mkdir $sitedest

	PLOTSdest=$sitedest/PLOTS
	mkdir $PLOTSdest


	cd $sitepath

	sublist=$(printf '%s\n' [0-9]* | paste -sd " ")


	for subid in $sublist
	do
		# Path for each id
		 subpath=$sitepath/$subid
		 MSEpath=$subpath/MSE_M1

		 cd $MSEpath
		 
		 cp ${subid}_M1_MSE.csv $sitedest

		 cd ../session_1/preproc_*

		 cp PLOTS/motion_plot.pdf $PLOTSdest/${subid}_motion_plot.pdf

		 ls $sitedest | wc -l

		cd $sitepath

	done

	cd $rootpath


done #outerloop